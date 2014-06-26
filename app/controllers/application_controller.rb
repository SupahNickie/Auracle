class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def reload_page
    redirect_to :back
  end

# if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
        guest_user.destroy
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session, creating one as needed
  def guest_user
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
    rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :role, :email, :password, :password_confirmation) }
  end

  private

  def create_guest_user
    u = User.create(:username => "Guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@example.com")
    u.save!(validate: false)
    session[:guest_user_id] = u.id
    u
  end

  def user_not_authorized
    flash[:error] = "Sorry, only the admin is allowed to do anything of value yet."
    redirect_to request.headers["Referer"] || root_path
  end

end
