class BranchDriverRelationshipsController < ApplicationController
  authorize_resource 
	
	def create
		driver  = User.where(email: params[:branch][:email]).first
		branch  = Branch.where(slug: params[:branch_id]).first
		company = Company.where(slug: params[:company_id]).first
		if driver
		  branch_relationship = BranchDriverRelationship.new
		  branch_relationship.branch_id = branch.id
		  branch_relationship.user_id   = driver.id
		  branch_relationship.active = false if current_user.is_admin?
		  branch_relationship.save
			flash[:notice] = "Driver added Successfully"
			redirect_to [company, branch]
		else
			flash[:error] = "Driver not found"
			redirect_to [company, branch]		
		end

		# current_user.follow user
  #   UserMailer.following_inform(current_user, user).deliver
	end

	def destroy
		driver  = User.find params["driver_id"]
		branch  = Branch.find params["branch_id"]
		company = Company.find params["company_id"]
		BranchDriverRelationship.where(user_id: driver.id, branch_id: branch.id).delete_all

		flash[:notice] = "Driver Deleted"
		redirect_to [company, branch]		
	end

private

	def user
		@_user ||= User.find(params[:user_id])
	end

end