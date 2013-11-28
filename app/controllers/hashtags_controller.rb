class HashtagsController < ApplicationController

	def show
		@search = Search.new(term: searchkeys)
	end

	private

	def searchkeys
		params[:id]
	end
end