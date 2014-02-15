class NetworksController < ApplicationController
	
	authorize_resource
	before_action :authorize_user, only: [:show]

  def show

		@network = Network.new(user)
  end

  def info
  end

  private

  	def authorize_user
	  	unless [user, 
	  					user.try(:inviter), 
	  					user.try(:inviter).try(:inviter), 
	  					user.try(:inviter).try(:inviter).try(:inviter)].include? current_user

	  		redirect_to network_path(current_user.slug), error:  "no access"
	  		return false
	  	end
  	end

  	def user
		  User.where(slug: params[:id]).first
  	end
end
