class Tweets::RetweetsController < ApplicationController

  def create
    tweet = Tweet.find(params[:tweet_id])
    UsersRetweet.create(tweet: tweet, user: current_user)
    redirect_back fallback_location: ''
  end

  def destroy
    tweet = Tweet.find(params[:tweet_id])
    UsersRetweet.find_by(tweet: tweet, user: current_user).destroy
    redirect_back fallback_location: ''
  end

end