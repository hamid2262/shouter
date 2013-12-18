class PhotoShoutsController < ShoutsController

	def destroy
		PhotoShout.find(params[:id]).destroy
		current_user.shouts.photo_shouts.find_by(content_id: params[:id]).destroy
		flash[:notice] = "deleted successfully!"
		redirect_to dashboard_path	
		return false	
	end
	  
  private

  def build_content
  	PhotoShout.new(photo_shout_params)	
  end

  def photo_shout_params
    params.fetch(:photo_shout, {}).permit(:image)
  end
  
end