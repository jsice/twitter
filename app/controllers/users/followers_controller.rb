class Users::FollowersController < ApplicationController
  def create
    user = find_user
    UserFollower.create(following: user, follower: current_user) if user != current_user
    redirect_back fallback_location: '/'
  end

  def destroy
    user = find_user
    UserFollower.find_by(following: user, follower: current_user)&.destroy
    redirect_back fallback_location: '/'
  end
  
  private
  def find_user
    User.find(params[:user_id]) or raise("not found")
  end
  
end
