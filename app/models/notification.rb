class Notification < ActiveRecord::Base
	belongs_to :notificationable, polymorphic: true
	belongs_to :user
	belongs_to :subtrip

	# scope :passenger, -> {self.notificationable.passenger}

	def self.booking_requests user
		ids = []
		ids = user.owned_branch.drivers.map{|u| u.id} if user.owned_branch
		ids = (ids + [user.id]).uniq
		notifications = Notification.where("user_id IN (?)", ids)
		notifications = notifications.where(notificationable_type: "Booking")
		notifications = notifications.where(note: "Booking Request")
		notifications
	end

	def self.booking_responds user
		notes = ["Request Accepted", "Request Rejected"]
		notifications = Notification.where(user_id: user.id)
		notifications = notifications.where(notificationable_type: "Booking")
		notifications = notifications.where("note IN (?)", notes)
		notifications
	end

	def passenger
		self.notificationable.passenger
	end

	def subtrip
		self.notificationable.subtrip
	end

  def self.clear_notificatins user, subtrip
    notes = Notification.where(user_id: user.id)
    notes = notes.where(subtrip_id: subtrip.id)
    notes = notes.where(notificationable_type: "Booking")
    notes = notes.where("note = ? OR note = ?", "Request Accepted", "Request Rejected")
    notes = notes.destroy_all
  end

end
