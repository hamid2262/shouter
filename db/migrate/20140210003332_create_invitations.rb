class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.belongs_to :inviter, index: true
      t.belongs_to :invited_user, index: true

      t.timestamps
    end
  end
end
