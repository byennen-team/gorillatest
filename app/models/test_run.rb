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
    channel_name = "scenario_#{scenario_id}_#{platform}_#{browser}_channel"
    puts "Steps size is #{steps.size}"
    puts "Channel name #{channel_name}"
    current_step = nil
    begin
      # Temp so we can test on autotest
      driver.navigate.to(steps.first.text)
      current_step = steps.first
      current_step.pass!
      steps.all.each do |step|
        puts "RUnning Step"
        current_step = step
        if step.event_type != "get"
          element = driver.find_element(:id, step.locator_value)
          if step.has_args?
              element.send(step.to_selenium, step.to_args)
          else
            element.send(step.to_selenium)
          end
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

end
