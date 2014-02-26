class AddLadiesOnlyToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :ladies_only, :boolean, default: false
  end
end
