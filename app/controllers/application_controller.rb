# class applicationcontroller
class ApplicationController < ActionController::Base
  include Pagy::Backend
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :current_password])
  end
  def find_user
    if current_user
      @user = User.find(current_user.id)
    else
      @user = User.new
      @user.name = 'Anonymous'
    end
    @user
  end
end
