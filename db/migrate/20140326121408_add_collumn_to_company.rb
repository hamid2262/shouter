class AddCollumnToCompany < ActiveRecord::Migration
  def change
    add_reference :companies, :user, index: true
    add_column :companies, :about, :text
  end
end
