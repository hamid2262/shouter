class AddCollumnsToUser < ActiveRecord::Migration

  def up
    add_column :users, :ulat, :float
    add_column :users, :ulng, :float
    add_column :users, :city, :string, limit: 80

    remove_column :users, :city_id
    remove_column :users, :post_code
    remove_column :users, :username

    add_index :users, [:ulat, :ulng]
   end

  def down
    add_column :users, :post_code, :string  
    add_column :users, :city_id, :integer  
    add_column :users, :username, :string

    remove_column :users, :ulat
    remove_column :users, :ulng
    remove_column :users, :city

    add_index :users, :username
   end
end
