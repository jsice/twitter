class TweetsController < ApplicationController
  layout 'main_with_sidebar'

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @tweets = Tweet.present
    @tweets = @tweets.search params[:search] if params[:search].present?
    @tweets = @tweets.order('published_at DESC').paginate(page: params[:page], per_page: 5)
    @new_tweet = Tweet.new (params.permit(:tweet_id))
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    offset = cookies["time_zone_offset"].to_i
    time_zone = ActiveSupport::TimeZone[-offset.minutes]
    tweet = current_user.tweets.new(tweet_params)
    tweet.published_at = time_zone.parse(params[:tweet][:published_at]) if params[:tweet][:published_at]
    tweet.deleted_at = time_zone.parse(params[:tweet][:deleted_at]) if params[:tweet][:deleted_at]
    tweet.save
    redirect_to tweets_path
  end

  def show
    @tweet = Tweet.find(params[:id]) or raise("not found")
    @replies = @tweet.replies.order('published_at DESC').paginate(page: params[:page], per_page: 5)
    @new_tweet = Tweet.new 
  end
  
  def destroy
    current_user.tweets.find(params[:id])&.destroy
    @tweet_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content, :tweet_id)
  end

end
