class Users::RegistrationsController < Devise::RegistrationsController
	
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def index
    @users = User.all
    authorize! :read, @users
  end

  def show
    @user = User.find(params[:id])
    @shouts = @user.shouts
    # @shouts = Shout.where(:user_id, params[:id])
  end
  
  def update
    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end

    # https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
    successfully_updated = if needs_password?(@user, user_params)
                             @user.update(user_params)
                           else
                             @user.update_without_password(user_params)
                           end
    respond_to do |format|
      if successfully_updated
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  # https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
  def needs_password?(user, params)
    params[:password].present?
  end
  
end