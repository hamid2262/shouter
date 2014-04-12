class FollowingRelationshipsController < ApplicationController

  authorize_resource 
	
	def create
		current_user.follow user
    UserMailer.following_inform(current_user, user).deliver
		redirect_to profile_url(user.slug), notice: t("following_message", name: user.name) 
	end

	def destroy
		current_user.unfollow user
		redirect_to profile_url(user.slug), notice: t("unfollowed_message", name: user.name) 
	end

private

	def user
		@_user ||= User.find(params[:user_id])
	end

end