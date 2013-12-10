class AddIndexToCity < ActiveRecord::Migration
  def change
  	add_index  :cities, [:latitude, :longitude] 
  	add_index  :cities, [:name] 
  	add_index  :cities, [:local_name] 
  end
end
