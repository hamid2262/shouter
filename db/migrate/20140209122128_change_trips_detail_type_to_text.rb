class ChangeTripsDetailTypeToText < ActiveRecord::Migration
  def change
  	change_column :trips, :detail, :text
  end
end
