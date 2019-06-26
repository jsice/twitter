class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :show_hashtags
  before_action :show_suggestions

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def show_hashtags
    @hashtags = ActsAsTaggableOn::Tag.most_used(10)
  end

  def show_suggestions
    @suggestions = current_user&.related_users[0..5]
  end
end
