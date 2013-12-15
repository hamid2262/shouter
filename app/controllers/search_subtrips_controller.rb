class SearchSubtripsController < ApplicationController

	def show
		@search_subtrips = SearchSubtrip.new(params[:search_subtrip])	
	end

end