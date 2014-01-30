require 'net/http'

class UrlInaccessible < Exception; end

class TestRun

  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :current_step, :channel_name

  field :browser, type: String
  field :platform, type: String
  field :status, type: String
  field :window_x, type: Integer
  field :window_y, type: Integer
  field :start_url, type: String
  field :screenshot_filename, type: String

  belongs_to :scenario
  embeds_many :steps

  before_create :save_window_size_and_url

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

  # def current_step
  #   @current_step
  # end

  # def channel_name
  #   @channel_name
  # end

  def run(current_user_id)
    begin
      @channel_name = "scenario_#{scenario_id}_#{platform}_#{browser}_channel"
      puts "Steps size is #{steps.size}"
      puts "Channel name #{channel_name}"

      if self.window_x && self.window_y
        driver.manage.window.resize_to(self.window_x, self.window_y)
      end

      @current_step = steps.first
      unless starting_url_success?(steps.first.text)
        raise UrlInaccessible
      end

      driver.navigate.to(current_step.text)
      current_step.pass!
      send_to_pusher

      steps.all.each do |step|
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
        puts "current step status is #{current_step.status}"
        send_to_pusher

      end
      puts ("setting test to pass")
      self.pass!
      driver.quit
    rescue Exception => e
      p "FAIL, SO TAKING A SCREENSHOT"
      png = driver.screenshot_as(:png)

      storage = Fog::Storage.new(:provider => 'AWS',
                       :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
                       :aws_secret_access_key => ENV['AWS_SECRET_KEY'])
      directory = storage.directories.get(ENV['S3_BUCKET'])
      file = directory.files.create(
        key: "screenshot_#{scenario_id}_#{self.id}_#{current_step.id}.png",
        body: png,
        public: true
      )

      driver.quit
      current_step.fail!
      send_to_pusher
      UserMailer.notify_failed_test(current_user_id, current_step ,self).deliver
    end
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

   def send_to_pusher
    # if step_attrs.empty?
    #   current_step.reload
    #   message = {status: current_step.status, to_s: current_step.to_s}
    # end
    Pusher[channel_name].trigger('step_pass', {
          message: current_step.as_json(methods: [:to_s])
    })
  end

  def save_window_size_and_url
    self.window_x = scenario.window_x
    self.window_y = scenario.window_y
    self.start_url = scenario.start_url
  end
end
