class FollowingRelationshipsController < ApplicationController

	def create
		current_user.follow user
		redirect_to user, notice: "Now you are following #{user.name}."
	end

	def destroy
		current_user.unfollow user
		redirect_to user, notice: "#{user.name} unfollowed."
	end

	private

	def user
		@_user ||= User.find(params[:user_id])
	end

end