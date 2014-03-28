class AddGroupToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :groupid, :integer
    add_index :trips, :groupid
  end
end
