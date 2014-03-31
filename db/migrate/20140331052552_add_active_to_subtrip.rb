class AddActiveToSubtrip < ActiveRecord::Migration
  def change
    add_column :subtrips, :active, :boolean, default: true
  end
end
