class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  
  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_locale
	after_filter :user_activity

  def redirect_to_profile_with_flash user, flash
    redirect_to profile_url(user)+"/"+locale.to_s, notice: flash
  end

  def profile_url user
     root_url[0..-3] + user.slug
  end
  helper_method :profile_url
  
  def lang_direction
    if params[:locale]=='fa' 
      'rtl'
    else 
      'ltr'
    end 
  end
  helper_method :lang_direction

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :gender
    end

    def check_for_mobile
      if current_user.mobile.blank?
        session[:back_url] = request.original_url
        flash[:error] = t("flash.mobile_message") 
        redirect_to edit_user_registration_path+'#contact_details'
      end
    end

	private

  	def user_activity
  	  current_user.try :touch
  	end

  
    def set_locale
      
      if params[:locale].present?
        I18n.locale = params[:locale]
        cookies[:locale] = params[:locale]
      else
        I18n.locale = cookies[:locale]
      end
      # current_user.locale
      # request.subdomain
      # request.env["HTTP_ACCEPT_LANGUAGE"]
      # request.remote_ip
    end
    
    def default_url_options(options = {})
      {locale: I18n.locale}
    end
    
end
