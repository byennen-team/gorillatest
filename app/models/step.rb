class Step
  include Mongoid::Document
  include Mongoid::Timestamps

  field :event_type, type: String
  field :locator_type, type: String
  field :locator_value, type: String
  field :text, type: String

  embedded_in :scenario

  # override for http auth
  def text
    if self.event_type == "waitForCurrentUrl" || self.event_type == "get"
      project = scenario.project
      if !project.basic_auth_username.blank?
        url_match = self[:text].match(/(https?:\/\/)(.+)/)
        return "#{url_match[1]}#{project.basic_auth_username}:#{project.basic_auth_password}@#{url_match[2]}"
      else
        return self[:text]
      end
    else
      return self[:text]
    end
  end


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
      return "Waiting for URL to load - #{self[:text]}"
    when "verifyText"
      return "Verifying text presence - #{text}"
    when "verifyElementPresent"
      return "Verify element presence - #{Rack::Utils.escape_html(text)}"
    when "get"
      return "Get URL - #{self[:text]}"
    when "assertConfirmation"
      return "Assert confirmation dialog with message - #{text}"
    when "chooseCancelOnNextConfirmation"
      return "Choose Cancel on Confirmation"
    when "chooseAcceptOnNextConfirmation"
      return "Choose Accept on Confirmation"
    end
  end

end
