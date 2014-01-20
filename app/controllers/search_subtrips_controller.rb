class SearchSubtripsController < ApplicationController

	skip_authorization_check
	before_action :initial_search_mode
	
	def show
		@subtrips = SearchSubtrip.all
		@search_subtrip = SearchSubtrip.new	
	end

	def search
		@search_subtrip = SearchSubtrip.new(params[:search_subtrip])
		if @search_subtrip.valid?
			@subtrips = @search_subtrip.subtrips(3) if @search_subtrip
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