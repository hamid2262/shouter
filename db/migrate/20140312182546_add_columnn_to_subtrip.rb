class AddColumnnToSubtrip < ActiveRecord::Migration
  def change
    add_column :subtrips, :origin_country_code, :string, limit: 5, default: "IR"
  end
end
