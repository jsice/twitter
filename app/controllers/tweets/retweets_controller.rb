class Tweets::RetweetsController < ApplicationController

  def create
    @tweet = find_tweet
    UsersRetweet.create(tweet: @tweet, user: current_user)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @tweet = find_tweet
    UsersRetweet.find_by(tweet: @tweet, user: current_user)&.destroy
    respond_to do |format|
      format.js
    end
  end

  private
  def find_tweet
    Tweet.find(params[:tweet_id]) or raise("not found")
  end

end