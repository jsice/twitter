class TweetsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @tweets = Tweet.present.order('published_at DESC').paginate(page: params[:page], per_page: 5)
    @new_tweet = Tweet.new (params.permit(:tweet_id))
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    offset = cookies["time_zone_offset"].to_i
    time_zone = ActiveSupport::TimeZone[-offset.minutes]
    @tweet = current_user.tweets.new(tweet_params)
    params[:tweet][:published_at] && @tweet.published_at = time_zone.parse(params[:tweet][:published_at])
    params[:tweet][:deleted_at] && @tweet.deleted_at = time_zone.parse(params[:tweet][:deleted_at])
    @tweet.save
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
