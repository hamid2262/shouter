class ShoutsController < ApplicationController
	
	load_and_authorize_resource 
  skip_load_resource only: [:create] 

	def show
		@shout = Shout.find(params[:id])	
	end

	def create
		content = build_content
		shout_save content
		flash[:notice] = massage(content)
		redirect_to dashboard_path
	end

	def destroy
		shout = current_user.shouts.find_by(content_id: params[:id])
		shout.content.destroy
		shout.destroy
		flash[:notice] = "deleted successfully!"
		redirect_to dashboard_path	
		return false	
	end

  protected

  def massage obj
  	if obj.valid?
  		"successfully shouted!"
  	else
	  	obj.errors.full_messages.first || "Could not shout"		
	  end
  end

  def shout_save content
		if content.valid? 
			shout = current_user.shouts.build(content: content)		
			shout.save
		end  	
  end  

end