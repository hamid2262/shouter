class AddColumnsToSubtrip < ActiveRecord::Migration
  def change
    add_column :subtrips, :origin_address_en, :string
    add_column :subtrips, :destination_address_en, :string
  end
end
