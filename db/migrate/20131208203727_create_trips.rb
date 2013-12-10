class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :total_available_seats, default: 8
      t.string :detail
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
