class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  
  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :message_notification
  before_action :booking_request_notifications
  before_action :booking_respond_notifications  
  after_action  :user_activity

  def lang_direction
    params[:locale]=='fa' ? 'rtl' :  'ltr' 
  end
  helper_method :lang_direction

  def lang_other_direction
    params[:locale]=='fa' ? 'ltr' :  'rtl' 
  end
  helper_method :lang_other_direction


  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :gender
    end

    def check_for_mobile
      if current_user.mobile.blank?
        session[:back_url] = request.original_url
        flash[:error] = t("flash.mobile_message") 
        return redirect_to edit_user_registration_path+'#contact_details'
      end
      false
    end

	private

  	def user_activity
  	  current_user.try :touch
  	end

  
    def set_locale
      # if Geocoder.search(request.remote_ip)[0].try(:country_code) == "DE"
      #   I18n.locale = :en
      # els
      # raise
      if cookies[:lang].present?
        I18n.locale = cookies[:lang].to_sym 
      elsif params[:locale].present?
        I18n.locale = params[:locale].to_sym 
      else
        I18n.locale = :fa 
      end
      # current_user.locale
      # request.subdomain
      # request.env["HTTP_ACCEPT_LANGUAGE"]
      # request.remote_ip
    end
    
    def default_url_options(options = {})
      {locale: I18n.locale}
    end
    
    def booking_request_notifications
      @booking_request_notifications = Notification.booking_requests(current_user) if current_user
    end

    def booking_respond_notifications
      @booking_respond_notifications = Notification.booking_responds(current_user) if current_user
    end

    def message_notification
      @unread_messages_notifications = Message.unread_messages_size(current_user) if current_user
    end


end
