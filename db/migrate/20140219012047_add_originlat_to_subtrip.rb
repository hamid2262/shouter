class AddOriginlatToSubtrip < ActiveRecord::Migration
  def change
    add_column :subtrips, :olat, :float
    add_column :subtrips, :olng, :float
    add_column :subtrips, :origin_city, :string, limit: 50
    add_column :subtrips, :origin_state, :string, limit: 50
    add_column :subtrips, :origin_country, :string, limit: 50
    add_column :subtrips, :origin_address, :string

    add_column :subtrips, :dlat, :float
    add_column :subtrips, :dlng, :float
    add_column :subtrips, :destination_city, :string, limit: 50
    add_column :subtrips, :destination_state, :string, limit: 50
    add_column :subtrips, :destination_country, :string, limit: 50
    add_column :subtrips, :destination_address, :string
    

    remove_column :subtrips, :origin_id
    remove_column :subtrips, :destination_id

  	add_index  :subtrips, [:date_time, :dlat, :dlng, :olat, :olng]
  end
end
