class AddCurrencyToSubtrip < ActiveRecord::Migration
  def change
    add_column :trips, :currency_id, :integer, default: 1
  end
end
