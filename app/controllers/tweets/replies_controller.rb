class Tweets::RepliesController < ApplicationController

  def reply
    @tweet = Tweet.find(params[:tweet_id])
  end

  def create
    @reply = current_user.tweets.create(reply_params)
    redirect_to tweet_path(@reply)
  end

  private

  def reply_params
    params.require(:tweet).permit(:content).merge(reply_id: params[:tweet_id])
  end

end
