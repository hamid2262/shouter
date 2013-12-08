class UsersController < Devise::RegistrationsController
  before_action :require_login

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def index
    @users = User.all
    authorize! :read, @users
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

    # if user_params[:password].blank?
    #   user_params.delete(:password)
    #   user_params.delete(:password_confirmation)
    # end
    # https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
    successfully_updated = if needs_password?(@user, user_params)
      @user.update_with_password(user_params)
    else
      params[:user].delete(:current_password)
      @user.update_without_password(user_params)
    end

    if successfully_updated
      redirect_to after_update_path_for(@user), notice: 'User was successfully updated.'
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
    params.require(:user).permit(:username, :email, :password, :password_confirmation,:current_password)
  end

  # https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
  def needs_password?(user, params)
    user.email != params[:email] ||
      params[:password].present?
  end
  
end