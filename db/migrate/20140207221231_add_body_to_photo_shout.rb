class AddBodyToPhotoShout < ActiveRecord::Migration
  def change
    add_column :photo_shouts, :body, :text
  end
end
