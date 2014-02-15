class AddViewTimesToSubtrip < ActiveRecord::Migration
  def change
    add_column :subtrips, :view, :integer, default: 0
  end
end
