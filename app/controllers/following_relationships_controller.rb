class FollowingRelationshipsController < ApplicationController

  load_and_authorize_resource 
  skip_load_resource only: [:create] 
	
	def create
		current_user.follow user
		redirect_to profile_url(user), notice: "Now you are following #{user.name}."
	end

	def destroy
		current_user.unfollow user
		redirect_to profile_url(user), notice: "#{user.name} unfollowed."
	end

	private

	def user
		@_user ||= User.find(params[:user_id])
	end

end