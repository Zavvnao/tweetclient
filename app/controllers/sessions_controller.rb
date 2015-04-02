class SessionsController < ApplicationController
  
  # Create session and home timeline of the 20 most recent tweets
  # Start the daemon script to receive tweets from Twitter
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
  	session[:username] = @user.id
    home_timeline_tweets = @user.twitter.home_timeline({:count => 20})
    home_timeline_tweets.reverse.each do |tweet|
      Tweet.create(:username => tweet.user.screen_name, :tweetbody => tweet.text)
    end
    system "ruby streaming_script.rb start"
    redirect_to root_path
  end

  # Destroy all records and stop Daemon script on logout
  def destroy
    system "ruby streaming_script.rb stop"
  	session[:username] = nil
    User.all.each do |user|
      user.destroy
    end
    User.reset_pk_sequence
    Tweet.all.each do |tweet|
      tweet.destroy
    end
    Tweet.reset_pk_sequence
  	reset_session
  	redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end