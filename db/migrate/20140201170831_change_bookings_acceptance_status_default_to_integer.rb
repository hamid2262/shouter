class ChangeBookingsAcceptanceStatusDefaultToInteger < ActiveRecord::Migration
  def up
  	remove_column :bookings, :accaptance_status
  	add_column :bookings, :accaptance_status, :integer, default: 0  	
  end
  def down
  	remove_column :bookings, :accaptance_status
  	add_column :bookings, :accaptance_status, :boolean, default: false
  end
end
