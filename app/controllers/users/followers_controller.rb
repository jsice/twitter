class Users::FollowersController < ApplicationController
  def create
    user = User.find(params[:user_id])
    UserFollower.create(following: user, follower: current_user) if user != current_user
    redirect_back fallback_location: ''
  end

  def destroy
    user = User.find(params[:user_id])
    UserFollower.find_by(following: user, follower: current_user)&.destroy
    redirect_back fallback_location: ''
  end
  
end
