class Message < ActiveRecord::Base
  belongs_to :contact

  def self.unread_messages_size user
    Contact.where(receiver_id: user.id, receiver_saw: false).size
  end

end
