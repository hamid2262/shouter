class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.belongs_to :notificationable, polymorphic: true
      t.belongs_to :user
      t.string     :note, limit: 20
      t.integer    :notifier_id
      t.integer    :subtrip_id

      t.timestamps
    end
    add_index :notifications, [:user_id, :notificationable_type, :note], name: "index_notifications_on_user_notificationable"
    add_index :notifications, [:user_id, :subtrip_id, :notificationable_type, :note], name: "index_notifications_on_subtrip_notificationable"
  end
end