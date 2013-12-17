class ReplaceImageWithPaperclipimageInVehicle < ActiveRecord::Migration
  def up
    remove_column 		:vehicles, :image
  	add_attachment    :vehicles, :image
  end

  def down
  	remove_attachment :vehicles, :image
  	add_column    		:vehicles, :image, :string
  end
end
