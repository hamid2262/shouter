class PhotoShoutsController < ShoutsController

  private

  def build_content
  	PhotoShout.new(photo_shout_params)	
  end

  def photo_shout_params
    params.fetch(:photo_shout, {}).permit(:image)
  end
  
end