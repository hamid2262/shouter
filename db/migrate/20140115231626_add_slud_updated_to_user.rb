class AddSludUpdatedToUser < ActiveRecord::Migration
  def change
    add_column :users, :slug_updated, :boolean, default: false
  end
end
