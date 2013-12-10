class CreateSubtrips < ActiveRecord::Migration
  def change
    create_table :subtrips do |t|
      t.belongs_to :trip, index: true
      t.integer :origin_id
      t.integer :destination_id
      t.datetime :datetime
      t.integer :price
      t.timestamps
    end
    add_index  :subtrips, [:datetime, :origin_id, :destination_id] 
    add_index  :subtrips, [:destination_id] 
    add_index  :subtrips, [:origin_id] 
  end
end
