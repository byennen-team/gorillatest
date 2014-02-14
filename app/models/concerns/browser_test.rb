require 'net/http'

class UrlInaccessible < Exception; end

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

    attr_accessor :current_step #, :channel_name
    # after_create :run_test
  end

  # Needs to be dynamic between FF, Chrome, PhantomJS
  def driver
    #selenium_url = "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub"
    selenium_url = "http://ec2-54-200-175-37.us-west-2.compute.amazonaws.com:4444/wd/hub"
    Rails.logger.debug("SELENIUM URL IS #{selenium_url}")
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

  def run(scenario)
    begin
      @current_step = scenario.steps.first
      puts "Current Step is #{@current_step.to_s}"
      unless starting_url_success?(scenario.steps.first.text)
        raise UrlInaccessible
      end

      if scenario.window_x && scenario.window_y
        driver.manage.window.resize_to(scenario.window_x, scenario.window_y)
      end
      driver.navigate.to(current_step.text)
      current_step.pass!
      save_history(current_step.to_s, current_step.status)
      #send_to_pusher

      scenario.steps.all.each do |step|
        next if step.event_type == "get"
        puts "Running Step"
        @current_step = step
        puts "Locator value is #{current_step.inspect}"
        if step.to_selenium != nil
          element = driver.find_element(step.locator_type, step.locator_value)
          puts "Element is #{element}"
          if step.has_args?
            puts "if element has args"
            element.send(step.to_selenium, step.to_args)
          else
            puts "if element has no args"
            if !element.displayed?
              puts "if element isn't visible"
              driver.execute_script("arguments[0].click()", element)
            else
              puts "if element visible"
              puts "Trying to click #{element}"
              element.send(step.to_selenium)
            end
          end
        elsif step.event_type == "waitForCurrentUrl"
          wait = Selenium::WebDriver::Wait.new(:timeout => 10)
          wait.until { driver.current_url  == step.text }
        elsif step.is_verification?
          p "VERIFICATION STUFF"
          dom_string = driver.execute_script("return document.documentElement.outerHTML")
          target = step.event_type == "verifyText" ? ">#{step.to_args[0]}<" : step.to_args[0]
          p "target string is #{target}"
          target = step.event_type == "verifyText" ? "#{step.to_args[0]}" : step.to_args[0]
          search = dom_string.scan(target)
          p "search result is #{search.inspect}"
          raise Selenium::WebDriver::Error::NoSuchElementError if search.empty?
        end
        puts 'Setting step to pass'
        current_step.pass!
        save_history(step.to_s, status)

        puts "current step status is #{current_step.status}"
        send_to_pusher

      end
      puts ("setting test to pass")
      self.pass!
      driver.quit
    rescue Exception => e
      p e.inspect
      p e.backtrace
      p "FAIL, SO TAKING A SCREENSHOT"
      png = driver.screenshot_as(:png)

      storage = Fog::Storage.new(:provider => 'AWS',
                       :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
                       :aws_secret_access_key => ENV['AWS_SECRET_KEY'])
      directory = storage.directories.get(ENV['S3_BUCKET'])
      file_name = "screenshot_#{scenario_test_run.scenario_id}_#{scenario_test_run.id}_#{self.platform}_#{self.browser}_#{current_step.id}.png"
      file = directory.files.create(
        key: file_name,
        body: png,
        public: true
      )
      self.update_attribute(:screenshot_filename, file_name)
      driver.quit
      current_step.fail!
      save_history(current_step.to_s, current_step.status)
      self.fail!
      send_to_pusher
    end
    self.test_run.complete
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
    response.code == "200" ? true : false
  end

   def send_to_pusher
    # if step_attrs.empty?
    #   current_step.reload
    #   message = {status: current_step.status, to_s: current_step.to_s}
    # end
    puts "pushing to channel #{channel_name}"
    Pusher[channel_name].trigger('features', {
          message: current_step.as_json(methods: [:to_s])
    })
  end

  # def run_test
  #   update_attribute(:queued_at, Time.now)
  #   TestWorker.perform_async("run_test", test_run.id.to_s, self.id.to_s)
  # end

end