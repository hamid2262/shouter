class UsersController < Devise::RegistrationsController

  # layout 'application_user', only: [:show]
  
  load_and_authorize_resource only: [:index, :show, :update, :edit, :destroy, :refresh]

  before_action :require_login, only: [:index, :show, :update, :edit]

  def index
    if params[:search]
      @users = User.order( params[:search]+ " DESC" ).limit(10)
    else
      @users = User.order(id: :desc).limit(10)
    end
  end

  def show
    @user = User.find(params[:id])
    @vehicle = @user.vehicle
  end
  
  def edit
    @user = current_user
  end

  def create
    build_resource(sign_up_params)

    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
      # my code 
      unless session[:inviter].nil?
        inviter = User.find(session[:inviter])
        inviter.invited_users << resource
        InvitationMailer.inform_inviter(resource, inviter).deliver
      end
      UserMailer.signup_inform_admin(resource).deliver
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def update
    # https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
    successfully_updated = if needs_password?(current_user, user_params)
      current_user.update_with_password(user_params)
    else
      params[:user].delete(:current_password)
      if current_user.is_admin?
        current_user.update_without_password(admin_user_params)          
      else
        current_user.update_without_password(user_without_password_params)  
      end
    end

    if successfully_updated
      if check_for_cover_or_avatar_update?
        redirect_to_profile_with_flash(current_user, t(:image_updated_message) )
      else
        if session[:back_url]
          redirect_to session[:back_url]
          session[:back_url] = nil
          return false
        else
          redirect_to user_path(current_user)+'#'+params[:user][:tab] , notice: t(:profile_updated_message)              
        end
      end
    else
      render action: 'edit', locals: {tab: params[:user][:tab]}
    end
  end

  def destroy
    unless current_user.is_admin?
      redirect_to root_url
      return false
    end  
  end

  def refresh
    redirect_to user_path(current_user)+'#'+params[:profile_tab]
    # or redirect_to :back (better IMO) 
  end
private

  def check_for_cover_or_avatar_update?
    false
    cover_updated  = (Time.now - current_user.cover_updated_at < 10) if current_user.cover_updated_at
    avatar_updated = (Time.now - current_user.avatar_updated_at < 10) if current_user.avatar_updated_at
    true if cover_updated || avatar_updated
  end

  def require_login
    unless user_signed_in?
      flash[:error] = t(:require_login)
      redirect_to new_user_session_url # halts request cycle
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,:current_password)
  end

  def user_without_password_params
    params.require(:user).permit(:firstname, :lastname, :slug,  :gender, :age, :tel, :mobile, :address, :city, :avatar, :cover)    
  end

  def admin_user_params
    params.require(:user).permit(:firstname, :lastname, :slug,  :gender, :age, :tel, :mobile, :address, :city, :avatar, :cover, :admin)
  end

  def needs_password?(user, params)
    # user.email != params[:email] ||
      params[:password].present?
  end

end