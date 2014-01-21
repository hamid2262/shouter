class FollowingRelationshipsController < ApplicationController

  load_and_authorize_resource 
  skip_load_resource only: [:create] 
	
	def create
		current_user.follow user
		redirect_to profile_url(user)+"/"+locale.to_s, notice: t(:following_message,name: user.name) 
	end

	def destroy
		current_user.unfollow user

		redirect_to profile_url(user)+"/"+locale.to_s, notice: t(:unfollowed_message,name: user.name)
	end

private

	def user
		@_user ||= User.find(params[:user_id])
	end

end