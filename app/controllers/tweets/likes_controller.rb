class Tweets::LikesController < ApplicationController

  def create
    tweet = Tweet.find(params[:tweet_id])
    Like.create(tweet: tweet, user: current_user)
    redirect_back fallback_location: ''
  end

  def destroy
    tweet = Tweet.find(params[:tweet_id])
    Like.find_by(tweet: tweet, user: current_user)&.destroy
    redirect_back fallback_location: ''
  end
  
end
