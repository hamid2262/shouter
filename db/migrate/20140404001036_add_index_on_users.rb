class AddIndexOnUsers < ActiveRecord::Migration

  def up
		remove_index :subtrips, column: [:date_time, :dlat, :dlng, :olat, :olng]
	  add_index :subtrips, [:date_time, :dlat, :dlng, :olat, :olng, :active], name: "index_subtrips_on_date_time_and_dlatlng_and_olatolng_active"
	  add_index :users, [:avatar_file_name]
  end

  def down
	  remove_index :users, [:avatar_file_name]
	  remove_index :subtrips, name: "index_subtrips_on_date_time_and_dlatlng_and_olatolng_active"
  	add_index  :subtrips, [:date_time, :dlat, :dlng, :olat, :olng]
  end

end
