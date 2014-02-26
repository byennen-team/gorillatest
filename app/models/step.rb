class Step
  include Mongoid::Document
  include Mongoid::Timestamps

 field :event_type, type: String
 field :locator_type, type: String
 field :locator_value, type: String
 field :text, type: String

  embedded_in :scenario

  def to_selenium
    case event_type
    when 'clickElement', 'submitElement'
      return 'click'
    when 'setElementText', 'setElementSelected'
      return 'send_keys'
    else
      return nil
    end
  end

  def to_args
   return [text]
  end

  def has_args?
    has_args = event_type == "setElementText" ? true : false
  end

  def is_verification?
    event_type == "verifyElementPresent" || event_type == "verifyText" ? true : false
  end

  def to_s
    case event_type
    when "setElementText"
      return "Set input value #{text} for element ##{locator_value}"
    when "setElementSelected"
        return "Set select element #{locator_value} to value #{text}"
    when "clickElement"
      return "Click element #{locator_value}"
    when "submitElement"
      return "Submit Form #{locator_value}"
    when "waitForCurrentUrl"
      return "Waiting for URL to load - #{text}"
    when "verifyText"
      return "Verifying text presence - #{text}"
    when "verifyElementPresent"
      return "Verify element presence - #{Rack::Utils.escape_html(text)}"
    when "get"
      return "Get URL - #{text}"
    when "assertConfirmation"
      return "Assert confirmation dialog with message - #{text}"
    when "chooseCancelOnNextConfirmation"
      return "Choose Cancel on Confirmation"
    when "chooseAcceptOnNextConfirmation"
      return "Choose Accept on Confirmation"
    end
  end

  def fail!
    update_attribute("status", "fail")
  end

  def pass!
    update_attribute("status", "pass")
  end
end
