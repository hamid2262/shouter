class HomesController < ApplicationController

	skip_authorization_check :only => [:show, :lang_select]

  def show
    redirect_to dashboard_path if current_user

		@search_subtrip = SearchSubtrip.new

		@subtrips = Home.newtrips.limit(8)

		@spacial_events = Home.spacial_events.limit(7)
  end

  def lang_select
  	if params[:lang] == "en"
  		cookies[:lang] = :en
  		new_url = params[:url].gsub! '/fa', '/en'
  	else
  		cookies[:lang] = :fa
  		new_url = params[:url].gsub! '/en', '/fa'
  	end
  	redirect_to new_url
  end
end
