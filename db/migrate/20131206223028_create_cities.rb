class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.belongs_to :state, index: true
      t.string :name
      t.string :local_name
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index  :cities, [:latitude, :longitude] 
    add_index  :cities, [:name] 
    add_index  :cities, [:local_name] 
  end
end
