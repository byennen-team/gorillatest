class TestSlot

  attr_accessor :test_slots
  attr_reader :platform, :browser

  def initialize(platform, browser)
    @platform = platform
    @browser = browser
  end

  def self.find_available(platform, browser)
    @test_slots = HTTParty.get("http://ec2-54-200-175-37.us-west-2.compute.amazonaws.com:4444/grid/api/status")["slots"]
    @test_slots["available"].each do |slot|
      return self.new(platform, browser) if platform_match?(platform, slot["platform"]) && slot["browserName"] == browser
    end
    false
  end

  def self.like_windows?(platform, slot_platform)
    platform.upcase == "WINDOWS" && (["VISTA"].include?(slot_platform)  || ["WIN8"].include?(slot_platform))
  end

  def self.platform_match?(platform, slot_platform)
    platform.upcase == slot_platform || like_windows?(platform, slot_platform)
  end
end
