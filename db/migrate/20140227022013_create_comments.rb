class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :shout_id
      t.integer :user_id
      t.text :body

      t.timestamps
    end
   	add_index  :comments, [:shout_id]
  end
end
