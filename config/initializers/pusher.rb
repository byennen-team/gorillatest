if Rails.env.development? || Rails.env.test?
  require 'pusher'
  Pusher.url = ENV["PUSHER_URL"]
  Pusher.logger = Rails.logger
  Pusher.app_id = ENV["PUSHER_APP_ID"]
  Pusher.key = ENV["PUSHER_KEY"]
  Pusher.secret = ENV["PUSHER_SECRET"]
end
