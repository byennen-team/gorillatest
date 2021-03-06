require 'net/http'

class UrlInaccessible < Exception; end
class AlertNotFound < Exception; end
class AlertInvalidText < Exception; end


module BrowserTest
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document
    include Mongoid::Timestamps
    include TestDuration

    field :browser, type: String
    field :platform, type: String
    field :status, type: String
    field :screenshot_filename, type: String
    field :retry_count, type: Integer, default: 0

    attr_accessor :current_step, :alert, :current_line_item #, :channel_name
    after_create :initialize_test_history
  end

  def delay
    if retry_count < 3
      return 30.seconds
    elsif retry_count.between?(3,5)
      return 60.seconds
    else
      return false
    end
  end

  def channel_name
    "#{test_run.id}_#{platform}_#{browser}_channel"
  end

  # Needs to be dynamic between FF, Chrome, PhantomJS
  def driver
    selenium_url = "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub"
    #selenium_url = "http://127.0.0.1:4444/wd/hub"
    # platform = ENV['BROWSER_TEST_PLATFORM'] if ENV['BROWSER_TEST_PLATFORM']
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
    when 'safari'
      cap = Selenium::WebDriver::Remote::Capabilities.safari
      cap.platform = platform.upcase.to_sym
      cap.javascript_enabled = true
      @driver ||= Selenium::WebDriver.for :remote, url: selenium_url, desired_capabilities: cap
    when 'ie9'
      cap = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      cap.platform = platform.upcase.to_sym
      cap.browser_name = "ie9"
      cap.javascript_enabled = true
      @driver ||= Selenium::WebDriver.for :remote, url: selenium_url, desired_capabilities: cap
    when 'ie10'
      cap = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      cap.platform = "WIN8"
      cap.browser_name = "ie10"
      cap.javascript_enabled = true
      @driver ||= Selenium::WebDriver.for :remote, url: selenium_url, desired_capabilities: cap
    when 'ie10'
      cap = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      cap.platform = "WIN8"
      cap.browser_name = "ie10"
      cap.javascript_enabled = true
      @driver ||= Selenium::WebDriver.for :remote, url: selenium_url, desired_capabilities: cap
    when 'ie11'
      cap = Selenium::WebDriver::Remote::Capabilities.internet_explorer
      cap.platform = "WIN8"
      cap.browser_name = "ie11"
      cap.javascript_enabled = true
      @driver ||= Selenium::WebDriver.for :remote, url: selenium_url, desired_capabilities: cap
    # when 'phantomjs'
    #   @driver ||= Selenium::WebDriver.for :remote, url: selenium_url, desired_capabilities: :phantomjs
    end
  end

  def run(scenario, history_line_item=nil)
    driver.manage.delete_all_cookies
    driver.manage.timeouts.implicit_wait = 3
    if history_line_item
      send_to_pusher("play_scenario", {scenario_id: scenario.id.to_s, scenario_name: scenario.name, test: self, num_total_steps: scenario.steps.count})
    end
    begin
      @current_step = scenario.steps.first
      unless starting_url_success?(scenario.steps.first.text)
        raise UrlInaccessible
      end

      if scenario.window_x && scenario.window_y
        driver.manage.window.resize_to(scenario.window_x, scenario.window_y)
      end
      driver.navigate.to(current_step.text)
      puts "Saving current line item"
      @current_line_item = save_history(current_step, current_step.to_s, "pass", history_line_item)

      send_to_pusher

      scenario.steps.all.each do |step|
        next if step.event_type == "get"
        @current_step = step
        if step.to_selenium != nil
          element = driver.find_element(step.locator_type, step.locator_value)
          if step.has_args?
            if step.event_type == "setElementText"
              element.clear
            end
            element.send(step.to_selenium, step.to_args)
          else
            if !element.displayed?
              if current_step.event_type == "setElementSelected"
                driver.execute_script("arguments[0].value = arguments[1]", element, current_step.text)
              else
                driver.execute_script("arguments[0].click()", element)
              end
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
          if step.event_type == "verifyElementPresent"
            element_text = driver.find_element(step.locator_type, step.locator_value).text()
            # Downcase because we record the actual text inside the element
            # Selenium returns it post CSS applied. - jkr
            unless element_text.downcase == step.to_args[0].downcase
              raise Selenium::WebDriver::Error::NoSuchElementError
            end
          else
            extract_all_text_from_dom = "function getTextContentExceptScript(element) {
                                          var text= [];
                                          for (var i= 0, n= element.childNodes.length; i<n; i++) {
                                              var child= element.childNodes[i];
                                              if (child.nodeType===1 && child.tagName.toLowerCase()!=='script')
                                                  text.push(getTextContentExceptScript(child));
                                              else if (child.nodeType===3)
                                                  text.push(child.data);
                                          }
                                          return text.join('');
                                        }; return getTextContentExceptScript(document);"

            dom_string = driver.execute_script(extract_all_text_from_dom)
            search = dom_string.scan(step.to_args[0])
            raise Selenium::WebDriver::Error::NoSuchElementError if search.empty?
          end
        end
        @current_line_item = save_history(step, step.to_s, "pass", history_line_item)
        send_to_pusher
      end
      set_completed_at_time
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
      @current_line_item = save_history(current_step, current_step.to_s, "fail", history_line_item)
      send_to_pusher
      set_completed_at_time
      return false
    end
  end

  def starting_url_success?(url)
    response = nil
    if !test_run.project.basic_auth_username.blank?
      auth = {username: test_run.project.basic_auth_username, password: test_run.project.basic_auth_password}
      response = HTTParty.get(url, basic_auth: auth)
    else
      uri = URI(url)
      response = Net::HTTP.get_response(uri)
    end
    response.code.to_s == "200" ? true : false
  end

  def send_to_pusher(event="step_pass", message=nil)
    if event == "step_pass"
      message = current_line_item.as_json(methods: [:to_s])
      steps_completed = self.is_a?(ScenarioBrowserTest) ? test_history.history_line_items.count : current_line_item.parent.children.count
      message.merge!({scenario_id: current_step.scenario.id.to_s, browser: browser, platform: platform,
                      steps_completed: steps_completed})
    else
      message = message.as_json
    end
    pusher_return = Pusher.trigger([channel_name], event, message)
  end

  def save_history(testable, msg, status, line_item=nil)
    if line_item.nil?
      line_item = test_history.history_line_items.create({testable: testable, text: msg, status: status, parent: id})
      return line_item
    else
      child = line_item.children.create({testable: testable, text: msg, status: status})
      return child
    end
  end

  def initialize_test_history
    create_test_history
  end


end
