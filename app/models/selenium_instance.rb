class SeleniumInstance
  include Mongoid::Document
  include Mongoid::Timestamps

  field :host_ip, type: String
  field :port, type: Integer

  field :platform, type: String
  field :browser, type: String
  field :status, type: String
  field :started_at, type: DateTime

  scope :by_platform_browser, ->(platform, browser) { where(platform: platform, browser: browser) }
  scope :available, -> { where(status: "available") }

  def self.next_available(platform, browser)
    by_platform_browser(platform, browser).available.first
  end
end
