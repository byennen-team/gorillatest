require 'net/http'

class TestRun

  include Mongoid::Document
  include Mongoid::Timestamps

  field :browser, type: String
  field :platform, type: String
  field :status, type: String

  belongs_to :scenario
  embeds_many :steps

  # Needs to be dynamic between FF, Chrome, PhantomJS
  def driver
    selenium_url = "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub"
    Rails.logger.debug("SELENIUM URL IS #{selenium_url}")
    case browser
    when 'firefox'
      @driver ||= Selenium::WebDriver.for :remote, url: selenium_url
    when 'chrome'
      @driver ||= Selenium::WebDriver.for :remote, url: selenium_url, desired_capabilities: :chrome
    when 'phantomjs'
      @driver ||= Selenium::WebDriver.for :remote, url: selenium_url, desired_capabilities: :phantomjs
    end
  end

  def run
    begin
      channel_name = "scenario_#{scenario_id}_#{platform}_#{browser}_channel"
      puts "Steps size is #{steps.size}"
      puts "Channel name #{channel_name}"
      current_step = nil
      # Temp so we can test on autotest

      unless starting_url_success?(steps.first.text)
        current_step = steps.first
        raise Selenium::WebDriver::Error::NoSuchElementError
      end

      current_step = steps.first
      driver.navigate.to(current_step.text)
      current_step.pass!

      Pusher[channel_name].trigger('step_pass', {
        message: current_step.as_json(methods: [:to_s])
      })

      steps.all.each do |step|
        next if step.event_type == "get"
        puts "Running Step"
        current_step = step
        puts "Locator value is #{current_step.inspect}"
        if step.event_type != "verifyElementPresent" && step.event_type != "verifyText"
          element = driver.find_element(step.locator_type, step.locator_value)
          if step.has_args?
              element.send(step.to_selenium, step.to_args)
          else
            if !element.displayed?
              driver.execute_script("arguments[0].click", element)
            else
              element.send(step.to_selenium)
            end
          end
        else
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

        Pusher[channel_name].trigger('step_pass', {
          message: current_step.as_json(methods: [:to_s])
        })

      end
      puts ("setting test to pass")
      self.pass!
      driver.quit
    rescue Exception => e
      driver.save_screenshot("/tmp/#{self.id}.png")
      puts e.inspect
      driver.quit
      current_step.fail!
      Pusher[channel_name].trigger('step_pass', {
        message: current_step.as_json(methods: [:to_s])
      })
      self.fail!
      driver.quit
    end
  end

  # This is just for our testing.
  def login_to_autotest
    if ENV["STAGING_USERNAME"] && ENV["STAGING_PASSWORD"]
      url = "http://#{ENV["STAGING_USERNAME"]}:#{ENV["STAGING_PASSWORD"]}@staging.autotest.io/users/sign_in"
    else
      url = "#{ENV["API_URL"]}/users/sign_in"
    end
    driver.navigate.to(url)
    driver.find_element(:id, "user_email").send_keys("jimiray@gmail.com")
    driver.find_element(:id, "user_password").send_keys("x4ja5fnm")
    driver.find_element(:name, "commit").click
  end

  def fail!
    update_attribute("status", "fail")
  end

  def pass!
    update_attribute("status", "pass")
  end

  private

  def starting_url_success?(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    response.code == "200" ? true : false
  end

end
