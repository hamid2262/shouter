class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :sender
      t.belongs_to :receiver
      t.boolean :receiver_saw, default: false

      t.timestamps
    end
    add_index :contacts, [:sender_id, :receiver_id]
    add_index :contacts, [:receiver_id, :receiver_saw]
  end
end
