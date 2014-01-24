class Step
  include Mongoid::Document
  include Mongoid::Timestamps

 field :event_type, type: String
 field :locator_type, type: String
 field :locator_value, type: String
 field :text, type: String
 field :status, type: String

  embedded_in :scenario
  embedded_in :test_run

  def to_selenium
    case event_type
    when 'clickElement'
      return 'click'
    when 'setElementText', 'setElementSelected'
      return 'send_keys'
    end
  end

  def to_args
    return [text]
  end

  def has_args?
    has_args = event_type == "setElementText" ? true : false
  end


  def to_s
    prefix = ""
    puts "Event type is #{event_type}"
    case event_type
    when "setElementText"
      prefix = "Set input value #{text} for element ##{locator_value}"
    when "setElementSelected"
      prefix = "Set select element #{locator_value} to value #{text}"
    when "clickElement"
      prefix = "Click element #{locator_value}"
    when "submitElement"
      prefix = "Submit Form #{locator_value}"
    when "waitForCurrentUrl"
      prefix = "Waiting for URL to load - #{text}"
    when "verifyText"
      prefix = "Verifying text presence - #{text}"
    when "verifyElementPresent"
      prefix = "Verify element presence - #{text}"
    when "get"
      prefix = "Get URL - #{text}"
    end
    puts "Prefix is #{prefix}"
    return prefix
  end

  def pass!
    update_attribute("status", "pass")
  end

  def fail!
    update_attribute("status", "fail")
  end

end
