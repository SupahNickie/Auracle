class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def reload_page
    redirect_to :back
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :role, :email, :password, :password_confirmation) }
  end

  private

  def user_not_authorized
    flash[:error] = "Sorry, only the admin is allowed to do anything of value yet."
    redirect_to request.headers["Referer"] || root_path
  end

end
