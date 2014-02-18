require 'net/http'

class UrlInaccessible < Exception; end
class AlertNotFound < Exception; end
class AlertInvalidText < Exception; end

module BrowserTest
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document
    include Mongoid::Timestamps

    field :browser, type: String
    field :platform, type: String
    field :status, type: String
    field :screenshot_filename, type: String
    field :queued_at, type: DateTime
    field :ran_at, type: DateTime
    field :run_time, type: Integer # in seconds

    attr_accessor :current_step, :alert #, :channel_name
    # after_create :run_test
  end

  # Needs to be dynamic between FF, Chrome, PhantomJS
  def driver
    #selenium_url = "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub"
    #selenium_url = "http://ec2-54-200-175-37.us-west-2.compute.amazonaws.com:4444/wd/hub"
    selenium_url = "http://127.0.0.1:4444/wd/hub"
    Rails.logger.debug("SELENIUM URL IS #{selenium_url}")
    platform = "mac"
    case browser
    when 'firefox'
      cap = Selenium::WebDriver::Remote::Capabilities.firefox
      cap.platform = platform.upcase.to_sym
      cap.javascript_enabled = true
      @driver ||= Selenium::WebDriver.for :remote, url: selenium_url, desired_capabilities: cap
    when 'chrome'
      cap = Selenium::WebDriver::Remote::Capabilities.chrome
      cap.platform = platform.upcase.to_sym
      cap.javascript_enabled = true
      @driver ||= Selenium::WebDriver.for :remote, url: selenium_url, desired_capabilities: cap
    when 'ie9'
      cap = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      cap.platform = platform.upcase.to_sym
      cap.javascript_enabled = true
      @driver ||= Selenium::WebDriver.for :remote, url: selenium_url, desired_capabilities: cap
    # when 'phantomjs'
    #   @driver ||= Selenium::WebDriver.for :remote, url: selenium_url, desired_capabilities: :phantomjs
    end
  end

  def run(scenario, history_line_item=nil)
    if history_line_item
      send_to_pusher("play_scenario", {scenario_id: scenario.id.to_s, scenario_name: scenario.name, test: self})
    end
    begin
      puts "Fetching scenario - #{scenario.name} URL"
      @current_step = scenario.steps.first
      unless starting_url_success?(scenario.steps.first.text)
        raise UrlInaccessible
      end

      if scenario.window_x && scenario.window_y
        driver.manage.window.resize_to(scenario.window_x, scenario.window_y)
      end
      driver.navigate.to(current_step.text)
      current_step.pass!
      save_history(current_step.to_s, current_step.status, history_line_item)

      send_to_pusher
      puts "Pushed to pusher"

      scenario.steps.all.each do |step|
        next if step.event_type == "get"
        @current_step = step
        if step.to_selenium != nil
          element = driver.find_element(step.locator_type, step.locator_value)
          if step.has_args?
            element.send(step.to_selenium, step.to_args)
          else
            if !element.displayed?
              driver.execute_script("arguments[0].click()", element)
            else
              element.send(step.to_selenium)
            end
          end
        elsif step.event_type == "assertConfirmation"
          @alert = driver.switch_to.alert
          if alert.text != step.text
            raise AlertInvalidText
          end
        elsif ["chooseCancelOnNextConfirmation", "chooseAcceptOnNextConfirmation"].include?(step.event_type)
          if alert
            if step.event_type == "chooseCancelOnNextConfirmation"
              alert.dismiss
            else
              alert.accept
            end
            alert = nil
          else
            raise AlertNotFound
          end
        elsif step.event_type == "waitForCurrentUrl"
          wait = Selenium::WebDriver::Wait.new(:timeout => 10)
          wait.until { driver.current_url  == step.text }
        elsif step.is_verification?
          dom_string = driver.execute_script("return document.documentElement.outerHTML")
          target = step.event_type == "verifyText" ? ">#{step.to_args[0]}<" : step.to_args[0]
          target = step.event_type == "verifyText" ? "#{step.to_args[0]}" : step.to_args[0]
          search = dom_string.scan(target)
          raise Selenium::WebDriver::Error::NoSuchElementError if search.empty?
        end
        current_step.pass!
        save_history(step.to_s, current_step.status, history_line_item)
        send_to_pusher
      end
      @driver = driver.quit
      return true
    rescue Exception => e
      p e.inspect
      p e.backtrace
      png = driver.screenshot_as(:png)
      storage = Fog::Storage.new(:provider => 'AWS',
                       :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
                       :aws_secret_access_key => ENV['AWS_SECRET_KEY'])
      directory = storage.directories.get(ENV['S3_BUCKET'])
      if history_line_item
        file_name = "screenshot_#{scenario.id}_#{history_line_item.id}_#{self.platform}_#{self.browser}_#{current_step.id}.png"
      else
        file_name = "screenshot_#{scenario.id}_#{self.platform}_#{self.browser}_#{current_step.id}.png"
      end

      file = directory.files.create(
        key: file_name,
        body: png,
        public: true
      )
      self.update_attribute(:screenshot_filename, file_name)
      @driver = driver.quit
      current_step.fail!
      save_history(current_step.to_s, current_step.status, history_line_item)
      send_to_pusher
      return false
    end
  end

  def fail!
    update_attribute("status", "fail")
  end

  def pass!
    update_attribute("status", "pass")
  end

  def starting_url_success?(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    puts response.inspect
    response.code == "200" ? true : false
  end

  def send_to_pusher(event="step_pass", message=nil)
    if event == "step_pass"
      message = current_step.as_json(methods: [:to_s])
      message.merge!({scenario_id: current_step.scenario.id.to_s})
    else
      message = message.as_json
    end
    pusher_return = Pusher.trigger([channel_name], event, message)
  end

end