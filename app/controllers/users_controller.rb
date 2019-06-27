class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @tweets = @user.tweets.order('published_at DESC').paginate(page: params[:page], per_page: 5)
  end
end
