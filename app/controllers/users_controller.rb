class UsersController < Devise::RegistrationsController

  layout 'application_user', only: [:show]
  
  load_and_authorize_resource only: [:index, :show, :update, :edit]

  before_action :require_login, only: [:index, :show, :update, :edit]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @shouts = @user.shouts
    @vehicle = @user.vehicle
    @followed_users = @user.followed_users.order(updated_at: :desc)
    # @shouts = Shout.where(:user_id, params[:id])
  end
  
  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)

    # https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
    successfully_updated = if needs_password?(@user, user_params)
      @user.update_with_password(user_params)
    else
      params[:user].delete(:current_password)
      if current_user.is_admin?
        @user.update_without_password(admin_user_params)          
      else
        @user.update_without_password(user_without_password_params)  
      end
    end

    if successfully_updated
      redirect_to @user , notice: "Profile was successfully updated."
    else
      render action: 'edit', locals: {tab: params[:user][:tab]}
    end
  end

private

  def require_login
    unless user_signed_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to new_user_session_url # halts request cycle
    end
  end

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation,:current_password)
  end

  def user_without_password_params
    params.require(:user).permit(:firstname, :lastname, :slug,  :gender, :city_id, :age, :tel, :mobile, :address, :post_code, :avatar, :cover)    
  end

  def admin_user_params
    params.require(:user).permit(:firstname, :lastname, :slug,  :gender, :city_id, :age, :tel, :mobile, :address, :post_code, :avatar, :cover, :admin)    
  end

  def needs_password?(user, params)
    # user.email != params[:email] ||
      params[:password].present?
  end
  
end