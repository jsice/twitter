class HashtagsController < ApplicationController
  def show
    @hashtag = params[:hashtag]
    @tweets = Tweet.tagged_with(@hashtag)
  end
end
