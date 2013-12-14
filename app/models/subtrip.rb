class Subtrip < ActiveRecord::Base
  belongs_to :trip
  belongs_to :origin, class_name: "City", foreign_key: "origin_id"
  belongs_to :destination, class_name: "City", foreign_key: "destination_id"
  has_many	 :bookings

  default_scope { order('datetime ASC') } 
end
