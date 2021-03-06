class HashtagsController < ApplicationController
  layout 'main_with_sidebar'

  skip_before_action :authenticate_user!, only: [:show]
  
  def show
    @hashtag = params[:hashtag]
    @tweets = Tweet.present.tagged_with(@hashtag).order('published_at DESC').paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
