class SearchSubtripsController < ApplicationController

	skip_authorization_check
	before_action :initial_search_mode
	def show
		@subtrips = SearchSubtrip.all
		@search_subtrip = SearchSubtrip.new	
		initial_select_mode_jday
	end

	def search
		@search_subtrip = SearchSubtrip.new(params[:search_subtrip])
		@subtrips = @search_subtrip.subtrips(3)
		initial_select_mode_jday
	end

	def choose_search_mode
		session['search_mode'] = params[:search_mode]
		redirect_to action: "search"		
	end

	private

		def initial_search_mode
			if session[:search_mode].nil?
				if request.ip.try(:country_code) == 'IR'
					session['search_mode'] = 'select'
				else
					session['search_mode'] = 'autocomplete'
				end
			end
		end

		def initial_select_mode_jday
			@search_subtrip.make_jdateـfor_search(session['search_mode'], params[:search_subtrip]) 
		end
end