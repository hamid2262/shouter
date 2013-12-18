class DashboardsController < ApplicationController

  load_and_authorize_resource

	def show
		@dashboard = Dashboard.new(current_user)
	end

end