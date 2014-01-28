require 'net/http'

class UrlNotCorrect < Exception; end

class TestRun

  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :current_step, :channel_name

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

  # def current_step
  #   @current_step
  # end

  # def channel_name
  #   @channel_name
  # end

  def run
    begin
      @channel_name = "scenario_#{scenario_id}_#{platform}_#{browser}_channel"
      puts "Steps size is #{steps.size}"
      puts "Channel name #{channel_name}"
      # Temp so we can test on autotest
      @current_step = steps.first
      unless starting_url_success?(steps.first.text)
        raise UrlNotCorrect
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
          if step.has_args?
              element.send(step.to_selenium, step.to_args)
          else
            if !element.displayed?
              driver.execute_script("arguments[0].click()", element)
            else
              element.send(step.to_selenium)
            end
          end
        elsif step.event_type == "waitForCurrentUrl"
          wait = Selenium::WebDriver::Wait.new(:timeout => 10)
          wait.until { driver.current_url  == step.text }
          # if driver.current_url != step.text
          #   raise UrlNotCorrect
          # end
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
      driver.save_screenshot("/tmp/#{self.id}.png")
      puts e.inspect
      driver.quit
      current_step.fail!
      send_to_pusher
      self.fail!
      driver.quit
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
    current_step.reload
    Pusher[channel_name].trigger('step_pass', {
          message: current_step.as_json(methods: [:to_s])
    })
  end

end
