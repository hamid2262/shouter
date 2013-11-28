class TextShoutsController < ShoutsController

  private

  def build_content
  	TextShout.new(text_shout_params)	
  end

  def text_shout_params
    params.require(:text_shout).permit(:body)
  end

end