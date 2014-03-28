class SearchSubtripsController < ApplicationController
  skip_authorization_check
	
	def search
		if params[:search_subtrip].nil?
			@search_subtrip = SearchSubtrip.new	
			@subtrips = @search_subtrip.newtrips.page(params[:page]).per_page(10)
			# @subtrips = @search_subtrip.subtrips_close_to_user request.remote_ip #"194.225.220.30" 
		else
			@search_subtrip = SearchSubtrip.new(params[:search_subtrip])
			if @search_subtrip.valid?
				@subtrips = @search_subtrip.subtrips(30).page(params[:page]).per_page(10) if @search_subtrip
			end			
		end
	end
end