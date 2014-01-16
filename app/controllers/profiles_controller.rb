class ProfilesController < ApplicationController  
  layout 'application_user', only: [:show]
	
	before_filter :authenticate_user!
	skip_authorization_check

	def show
		user = User.find_by!(slug: params[:id])
		@profile = Profile.new(user)
    @followed_users = user.followed_users.order(updated_at: :desc)

		# @followed_users = @profile.followed_users
		@random_users = @profile.random_users
	end

  # def show
  #   user = User.find(params[:id])
  #   @shouts = user.shouts
  #   @vehicle = user.vehicle
  #   @followed_users = user.followed_users.order(updated_at: :desc)
  # end

end
