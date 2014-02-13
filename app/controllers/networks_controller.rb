class NetworksController < ApplicationController
	
	load_and_authorize_resource

  def mynet
		@mynet = Network.new(current_user)
  end

  def info
  end
end
