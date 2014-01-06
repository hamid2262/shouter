class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  before_filter :configure_permitted_parameters, if: :devise_controller?
	after_filter :user_activity

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :gender
    end

	private

  	def user_activity
  	  current_user.try :touch
  	end

end
