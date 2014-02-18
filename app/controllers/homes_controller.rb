class HomesController < ApplicationController

	skip_authorization_check :only => [:show, :create]

  def show
    redirect_to dashboard_path if current_user

		@search_subtrip = SearchSubtrip.new

		@subtrips = Home.newtrips.limit(7)

		@spacial_events = Home.spacial_events.limit(7)
  end

end
