class AddOlatOlngToSpacialEvent < ActiveRecord::Migration
  def change
    add_column :spacial_events, :olat, :float
    add_column :spacial_events, :olng, :float
    add_column :spacial_events, :origin_city, :string, limit: 50
    add_column :spacial_events, :origin_state, :string, limit: 50
    add_column :spacial_events, :origin_country, :string, limit: 50
    add_column :spacial_events, :origin_address, :string

    add_column :spacial_events, :dlat, :float
    add_column :spacial_events, :dlng, :float
    add_column :spacial_events, :destination_city, :string, limit: 50
    add_column :spacial_events, :destination_state, :string, limit: 50
    add_column :spacial_events, :destination_country, :string, limit: 50
    add_column :spacial_events, :destination_address, :string
    
    remove_column :spacial_events, :origin_id
    remove_column :spacial_events, :destination_id
  end
end
