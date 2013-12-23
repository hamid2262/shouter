class CreateSubtrips < ActiveRecord::Migration
  def change
    create_table :subtrips do |t|
      t.belongs_to :trip, index: true
      t.integer :origin_id
      t.integer :destination_id
      t.datetime :date_time
      t.integer  :jyear
      t.integer  :jmonth
      t.integer  :jday
      t.integer  :jhour
      t.integer  :jminute
      t.integer :price
      t.integer :seats, array: true, default: []
      t.timestamps
    end
    add_index  :subtrips, [:date_time, :origin_id, :destination_id] 
    add_index  :subtrips, [:destination_id] 
    add_index  :subtrips, [:origin_id] 
  end
end