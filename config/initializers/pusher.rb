require 'pusher'

Pusher.url = "http://963dba5416414fb92c8f:6b004db0659f6eb150d9@api.pusherapp.com/apps/64224"
Pusher.logger = Rails.logger

Pusher.app_id = ENV["PUSHER_APP_ID"]
Pusher.key = ENV["PUSHER_KEY"]
Pusher.secret = ENV["PUSHER_SECRET"]
