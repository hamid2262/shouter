class AddIndexToContacts < ActiveRecord::Migration
  def up
    remove_index :contacts, [:sender_id,   :receiver_id]
    add_index    :contacts, [:sender_id,   :receiver_id, :updated_at]
    add_index    :contacts, [:receiver_id, :sender_id, :updated_at]
  end

  def down
    remove_index :contacts, [:receiver_id, :sender_id,    :updated_at]
    remove_index :contacts, [:receiver_id, :receiver_saw, :updated_at]
    add_index    :contacts, [:sender_id,   :receiver_id]
  end
end
