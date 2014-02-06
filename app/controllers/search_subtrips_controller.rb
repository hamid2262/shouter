class SearchSubtripsController < ApplicationController
  
  layout 'application_user', only: [:special_events]

	skip_authorization_check
	before_action :initial_search_mode
	
	def search
		if params[:search_subtrip].nil?
			@search_subtrip = SearchSubtrip.new	
			@subtrips = @search_subtrip.newtrips.page(params[:page]).per_page(10)
			# @subtrips = @search_subtrip.subtrips_close_to_user request.remote_ip #"194.225.220.30" 
		else
			@search_subtrip = SearchSubtrip.new(params[:search_subtrip])
			if @search_subtrip.valid?
				@subtrips = @search_subtrip.subtrips(3).page(params[:page]).per_page(10) if @search_subtrip
			end			
		end
	end

	def special_events
		@search_subtrip = SearchSubtrip.new(params[:search_subtrip])
		@search_subtrip.origin_name = 'تبريز'
		@search_subtrip.origin_lat = 38.0666667
		@search_subtrip.origin_lng = 46.3
		@search_subtrip.origin_id = 1
		@search_subtrip.origin_cycle = 200


		@search_subtrip.destination_name = 'كرمان'
		@search_subtrip.destination_lat = 30.28027
		@search_subtrip.destination_lng = 57.06702
		@search_subtrip.destination_id = 297
		@search_subtrip.destination_cycle = 200

		@subtrips = @search_subtrip.subtrips(17).page(params[:page]).per_page(10) if @search_subtrip
	end

	def choose_search_mode
		session[:return_to] ||= request.referer
		session['search_mode'] = params[:search_mode]
		if session[:return_to]
			redirect_to session.delete(:return_to)
		else
			redirect_to root_path
		end
	end

	private

		def initial_search_mode
			if session[:search_mode].nil?
				# if request.ip.try(:country_code) == 'IR'
				# 	session['search_mode'] = 'select'
				# else
					session['search_mode'] = 'autocomplete'
				# end
			end
		end

end