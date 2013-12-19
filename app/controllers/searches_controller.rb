class SearchesController < ApplicationController
	skip_authorization_check	

	def show
		@search = Search.new(params[:search])	
	end

end