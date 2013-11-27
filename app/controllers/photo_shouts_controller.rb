class PhotoShoutsController < ApplicationController

	def create
		content = build_content
		if content.valid? 		
			shout = current_user.shouts.build(content: content)	
			if shout.save
				redirect_to dashboard_path, notice: "successfully shouted!"
				return false
			end	
		end
		raise content.errors.to_yaml
	return false	
		redirect_to dashboard_path, notice: "Could not shout"		
	end

  private

  def build_content
  	PhotoShout.new(photo_shout_params)	
  end

  def photo_shout_params
    params.require(:photo_shout).permit(:image)
  end

end