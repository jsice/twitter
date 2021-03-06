class UsersController < ApplicationController
  layout 'main_with_sidebar'
  
  def show
    @user = User.find(params[:id])
    @tweets = @user.tweets.present.order('published_at DESC').paginate(page: params[:page], per_page: 5)
    @followers = @user.followers.paginate(page: params[:page], per_page: 15)
    @followings = @user.followings.paginate(page: params[:page], per_page: 15)
    @tweets_size = @user.tweets.present.size
    @followers_size = @user.followers.size
    @followings_size = @user.followings.size
    respond_to do |format|
      format.html
      format.js
    end
  end
end
