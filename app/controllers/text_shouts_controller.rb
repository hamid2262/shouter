class TextShoutsController < ShoutsController
	load_and_authorize_resource 
  skip_load_resource only: [:destroy, :create] 
	def destroy
		TextShout.find(params[:id]).destroy
		current_user.shouts.text_shouts.find_by(content_id: params[:id]).destroy
		flash[:notice] = "deleted successfully!"
		redirect_to dashboard_path	
		return false	
	end

  private

  def build_content
  	TextShout.new(text_shout_params)	
  end

  def text_shout_params
    params.require(:text_shout).permit(:body)
  end

end