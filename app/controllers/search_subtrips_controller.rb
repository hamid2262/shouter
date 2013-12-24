class SearchSubtripsController < ApplicationController

	skip_authorization_check	

	def show
		@subtrips = SearchSubtrip.all
	end

	def search
		@search_subtrip = SearchSubtrip.new(params[:search_subtrip])			
	end
end