class Step
  include Mongoid::Document
  include Mongoid::Timestamps

 field :event_type, type: String
 field :locator_type, type: String
 field :locator_value, type: String
 field :text, type: String

  embedded_in :scenario


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
      prefix = "Verifying text - #{text}"
    when "verifyElementPresent"
      prefix = "Verifiy element present - #{text}"
    when "get"
      prefix = "Get URL - #{text}"
    end
    puts "Prefix is #{prefix}"
    return prefix
  end

end
