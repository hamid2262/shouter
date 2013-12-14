class Booking < ActiveRecord::Base
  belongs_to :passenger, class_name: "User", foreign_key: "user_id"
  belongs_to :subtrip

  # after_save :take_subtrip_seats
  # after_destroy :release_subtrip_seats

  # def take_subtrip_seats
  # 	self.subtrip.seats = 
  # end
end
