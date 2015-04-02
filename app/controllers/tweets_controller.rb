class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  respond_to :html
  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.all.reverse
    respond_with(@tweets)
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    respond_with(@tweet)
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
    respond_with(@tweet)
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)
    if @tweet.username == nil
      # This is for the current user posting tweets
      @tweet.username = current_user.name
      @tweet.user_id = current_user.id
      # Updates to Twitter
      current_user.twitter.update(@tweet.tweetbody)
    else 
      # Incoming tweets from the daemon script
      @tweet.save
    end
    respond_with(@tweet)
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    @tweet.update(tweet_params)
    respond_with(@tweet)
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_with(@tweet)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:username, :tweetbody)
    end

  helper_method :refresh
end
