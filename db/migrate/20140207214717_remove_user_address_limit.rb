class RemoveUserAddressLimit < ActiveRecord::Migration
  def change
  	change_column :users, :address, :string, :limit => 255
  end
end
