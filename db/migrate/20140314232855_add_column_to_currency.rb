class AddColumnToCurrency < ActiveRecord::Migration
  def change
    add_column :currencies, :unit_price, :float
    add_column :currencies, :price_step, :integer
    add_column :subtrips,   :currency_id, :integer
  end
end
