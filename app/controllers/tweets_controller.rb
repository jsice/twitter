class TweetsController < ApplicationController

  def index
    @tweets = Tweet.all
  end

  def create
    @tweet = Tweet.new(tweet_params)
    redirect_to tweets_path
  end

  def show
    @tweet = Tweet.find(params[:id])
  end
  
  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    redirect_to tweets_path
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end

end
