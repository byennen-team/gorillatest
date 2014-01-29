class Scenario

  attr_accessor :driver

 include Mongoid::Document

 field :name, type: String
 
 field :event_type, type: String
 field :locator_type, type: String
 field :locator_value, type: String
 field :text, type: String
 field :window_x, type: Integer
 field :window_y, type: Integer
 field :start_url, type: String

 #embedded_in :feature
 belongs_to :feature

 embeds_many :steps

 has_many :test_runs

 validates :name, presence: true, uniqueness: {scope: :feature}

  def driver
    @driver ||= Selenium::WebDriver.for :remote, 
                                        :url => "http://localhost:4444/wd/hub", 
                                        :desired_capabilities => :safari
  end

  def run
    puts "Steps size is #{steps.size}"
    begin
      login_to_autotest
      driver.navigate.to(steps.first.text)
      steps.all.each do |step|
        if step.event_type != "get"
          element = driver.find_element(:id, step.locator_value)
          if step.has_args?
              element.send(step.to_selenium, step.to_args)
          else
            element.send(step.to_selenium)
          end
        end
      end
      driver.close
    rescue Exception => e
      driver.save_screenshot("tmp/#{self.id}.png")
      puts e.inspect
    end
  end

  def login_to_autotest
    driver.navigate.to("http://autotest.dev/users/sign_in")
    driver.find_element(:id, "user_email").send_keys("jimiray@gmail.com")
    driver.find_element(:id, "user_password").send_keys("x4ja5fnm")
    driver.find_element(:name, "commit").click
  end

end
