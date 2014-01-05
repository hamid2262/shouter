class PhotoShoutsController < ShoutsController

	load_and_authorize_resource 
  skip_load_resource only: [:create] 

  private

  def build_content
  	PhotoShout.new(photo_shout_params)	
  end

  def photo_shout_params
    params.fetch(:photo_shout, {}).permit(:image)
  end
  
end