class HashtagsController < ApplicationController
  def show
    @hashtag = params[:hashtag]
    @tweets = Tweet.tagged_with(@hashtag).order('published_at DESC').paginate(page: params[:page], per_page: 5)
  end
end
