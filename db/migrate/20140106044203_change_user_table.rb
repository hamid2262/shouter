class ChangeUserTable < ActiveRecord::Migration
  def up
  	change_column_default :users, :gender, nil
		add_column :users, :age, :integer
		add_attachment :users, :cover
  end

  def down
  	remove_attachment :users, :cover
  	remove_column :users, :age
  	change_column_default :users, :gender, 'male'
  end  
end
