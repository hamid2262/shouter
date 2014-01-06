class DashboardsController < ApplicationController

	before_filter :authenticate_user!
	skip_authorization_check
	def show
		@dashboard = Dashboard.new(current_user)
		@followed_users = current_user.followed_users.order(updated_at: :desc)
		@random_users = User.where.not(id: current_user.id).order(updated_at: :desc)
	end

end