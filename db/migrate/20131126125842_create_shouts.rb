class CreateShouts < ActiveRecord::Migration
  def change
    create_table :shouts do |t|
      t.string :content_type
      t.integer :content_id
      t.belongs_to :user, index: true

      t.timestamps
    end
  	add_index  :shouts, [:content_type, :content_id]   # 
  end
end