class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.belongs_to :user, index: true
      t.belongs_to :subtrip, index: true
      t.boolean :accaptance_status, default: false
      t.timestamps
    end
  end
end
