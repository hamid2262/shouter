class DashboardsController < ApplicationController

	before_filter :authenticate_user!
	skip_authorization_check
	def show
		@dashboard      = Dashboard.new(current_user)
		@followed_users = @dashboard.followed_users
		@followers      = @dashboard.followers
		@random_users   = @dashboard.random_users
	end

end