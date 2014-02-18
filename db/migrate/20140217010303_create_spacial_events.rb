class CreateSpacialEvents < ActiveRecord::Migration
  def change
    create_table :spacial_events do |t|
      t.string :title
      t.attachment :image
      t.string :permalink
      t.integer :origin_id
      t.integer :destination_id
      t.integer :origin_cycle
      t.integer :destination_cycle
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    add_index :spacial_events, :permalink
    
  end
end
