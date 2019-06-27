class Tweets::LikesController < ApplicationController

  def create
    tweet = find_tweet
    Like.create(tweet: tweet, user: current_user)
    redirect_back fallback_location: ''
  end

  def destroy
    tweet = find_tweet
    Like.find_by(tweet: tweet, user: current_user)&.destroy
    redirect_back fallback_location: ''
  end
  
  private
  def find_tweet
    Tweet.find(params[:tweet_id]) or raise("not found")
  end

end
