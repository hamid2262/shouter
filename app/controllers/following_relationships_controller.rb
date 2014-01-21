class FollowingRelationshipsController < ApplicationController

  load_and_authorize_resource 
  skip_load_resource only: [:create] 
	
	def create
		current_user.follow user
		redirect_to_profile_with_flash(user, t(:following_message,name: user.name) )
	end

	def destroy
		current_user.unfollow user
		redirect_to_profile_with_flash(user, t(:unfollowed_message,name: user.name) )
	end

private

	def user
		@_user ||= User.find(params[:user_id])
	end

end