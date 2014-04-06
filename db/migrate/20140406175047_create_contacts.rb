class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :sender, index: true
      t.belongs_to :receiver, index: true
      t.boolean :receiver_saw

      t.timestamps
    end
    add_index :contacts, [:sender_id, :receiver_id]
    add_index :contacts, [:receiver_id, :receiver_saw]
  end
end
