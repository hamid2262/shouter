class TextShoutsController < ApplicationController

	def create
		content = build_content
		if content.valid? 
			shout = current_user.shouts.build(content: content)		
			if shout.save
				redirect_to dashboard_path, notice: "successfully shouted!"
				return false
			end	
		end
		redirect_to dashboard_path, notice: "Could not shout"		
	end

  private

  def build_content
  	TextShout.new(text_shout_params)	
  end

  def text_shout_params
    params.require(:text_shout).permit(:body)
  end

end