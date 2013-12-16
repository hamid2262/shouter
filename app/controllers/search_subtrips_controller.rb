class SearchSubtripsController < ApplicationController

	def show
	end

	def search
		@search_subtrips = SearchSubtrip.new(params[:search_subtrip])			
	end
end