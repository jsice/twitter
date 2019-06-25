class TweetsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @tweets = Tweet.order('created_at DESC').paginate(page: params[:page], per_page: 5)
    # @tweets = Tweet.all
    @new_tweet = Tweet.new (params.permit(:tweet_id))
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @tweet = current_user.tweets.create(tweet_params)
    redirect_to tweets_path
  end

  def show
    @tweet = Tweet.find(params[:id])
    @new_tweet = Tweet.new 
  end
  
  def destroy
    @tweet = current_user.tweets.find(params[:id])
    @tweet.destroy
    redirect_to tweets_path
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content, :tweet_id)
  end

end
