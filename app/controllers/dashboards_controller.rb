class DashboardsController < ApplicationController

	before_filter :authenticate_user!
	skip_authorization_check
	def show
		@dashboard      = Dashboard.new(current_user)
		# @timeline       = Shout.where(user_id: @dashboard.shout_user_ids)

		@timeline = @dashboard.timeline.page(params[:page]).per_page(10)

		@followed_users = @dashboard.followed_users
		@followers      = @dashboard.followers
		@random_users   = @dashboard.random_users
	end

end