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
    case browser
    when 'firefox'
      @driver ||= Selenium::WebDriver.for :remote, :url => "http://localhost:4444/wd/hub"
    when 'chrome' 
      @driver ||= Selenium::WebDriver.for :remote, :url => "http://localhost:4444/wd/hub", :desired_capabilities => :chrome
    when 'phantomjs'
      @driver ||= Selenium::WebDriver.for :remote, :url => "http://localhost:4444/wd/hub", :desired_capabilities => :phantomjs
    end
  end

  def run
    puts "Steps size is #{steps.size}"
    current_step = nil    
    begin
      login_to_autotest
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
      end
      driver.close
      puts ("setting test to pass")
      self.pass!
    rescue Exception => e
      driver.save_screenshot("tmp/#{self.id}.png")
      puts e.inspect
      current_step.fail!
      self.fail!
    end
  end

  # This is just for our testing.
  def login_to_autotest
    driver.navigate.to("http://autotest.dev/users/sign_in")
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

    def add_to_sidekiq
      TestWorker.perform_async(self.id.to_s)
    end

end
