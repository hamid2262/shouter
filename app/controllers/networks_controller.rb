class NetworksController < ApplicationController
	
	authorize_resource
	before_action :authorize_user, only: [:show]

  def show
		@network = Network.new(user)
  end

  private
  	def authorize_user
	  	if !([user, 
	  		  					user.try(:inviter), 
	  		  					user.try(:inviter).try(:inviter), 
	  		  					user.try(:inviter).try(:inviter).try(:inviter)].include? current_user) && !current_user.is_admin?
	  		redirect_to network_path(current_user.slug), error:  "no access"
	  		return false
	  	end
  	end

  	def user
		  User.where(slug: params[:id]).first
  	end
end
