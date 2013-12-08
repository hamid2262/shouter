class CreateSubtrips < ActiveRecord::Migration
  def change
    create_table :subtrips do |t|
      t.belongs_to :trip, index: true
      t.datetime :datetime
      t.integer :price

      t.timestamps
    end
  end
end
