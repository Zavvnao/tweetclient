# This is the daemon script to open a stream to user timeline

ENV["RAILS_ENV"] ||= "development"

root = File.expand_path(File.join(File.dirname(__FILE__), '.'))
require File.join(root, "config", "environment")

# Configures the oauth values
TweetStream.configure do |config|
  config.consumer_key = Rails.application.secrets.twitter_api_key
  config.consumer_secret = Rails.application.secrets.twitter_api_secret
  config.oauth_token = User.first.token
  config.oauth_token_secret = User.first.secret
end

# Create a new daemon from TweetStream gem
daemon = TweetStream::Daemon.new('tracker', :log_output => true)

# Start the daemon
daemon.on_inited do
  ActiveRecord::Base.connection.reconnect!
end

daemon.on_error do |message|
  puts "on_error: #{message}"
end

daemon.on_reconnect do |timeout, retries|
  puts "on_reconnect: #{timeout}, #{retries}"
end

daemon.on_limit do |discarded_count|
  puts "on_limit: #{skip_count}"
end

# Start streaming userstream and add record to database when a
# new tweet comes in
daemon.userstream do |status|
  puts status.text
  Tweet.create(:username => status.user.screen_name, :tweetbody => status.text)
end
