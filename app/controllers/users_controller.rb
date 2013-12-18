class UsersController < Devise::RegistrationsController

  load_and_authorize_resource only: [:index, :show, :update, :edit]

  before_action :require_login, only: [:index, :show, :update, :edit]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @shouts = @user.shouts
    @vehicle = @user.vehicle
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
      @user.update_without_password(user_without_password_params)
    end

    if successfully_updated
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: 'edit'
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
    params.require(:user).permit(:email, :password, :password_confirmation,:current_password)
  end

  def user_without_password_params
    params.require(:user).permit(:username,:firstname, :lastname, :gender, :tel, :mobile, :address, :post_code, :image)    
  end

  def needs_password?(user, params)
    user.email != params[:email] ||
      params[:password].present?
  end
  
end