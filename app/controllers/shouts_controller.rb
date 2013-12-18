class ShoutsController < ApplicationController
	
	skip_authorization_check

	def show
		@shout = Shout.find(params[:id])	
	end

	def create
		content = build_content
		shout_save content
		flash[:notice] = massage(content)
		redirect_to dashboard_path
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