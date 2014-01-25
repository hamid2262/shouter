class SearchSubtripsController < ApplicationController

	skip_authorization_check
	before_action :initial_search_mode
	
	def search
		if params[:search_subtrip].nil?
			@subtrips = SearchSubtrip.all.page(params[:page]).per_page(10)
			# @search_subtrip = SearchSubtrip.new	
			# @subtrips = @search_subtrip.subtrips_close_to_user request.remote_ip #"194.225.220.30" 
		else
			@search_subtrip = SearchSubtrip.new(params[:search_subtrip])
			if @search_subtrip.valid?
				@subtrips = @search_subtrip.subtrips(3) if @search_subtrip
			end			
		end

	end

	def choose_search_mode
		session[:return_to] ||= request.referer
		session['search_mode'] = params[:search_mode]
		redirect_to session.delete(:return_to)	
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