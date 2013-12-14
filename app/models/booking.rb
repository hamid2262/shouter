class Booking < ActiveRecord::Base
  belongs_to :passenger, class_name: "User", foreign_key: "user_id"
end
