class Booking < ActiveRecord::Base
  belongs_to :passenger, class_name: "User", foreign_key: "user_id"
  belongs_to :subtrip

  # after_save :take_subtrip_seats
  # after_destroy :release_subtrip_seats

  def self.create_new_seats_array params, current_user
    new_seats_array = []
    params[:seat_numbers].each do |k,v|
      if v == "F"
        new_seats_array << 0
      elsif v=="T"
        new_seats_array << current_user.id
      else
        new_seats_array << v.to_i
      end
    end
    new_seats_array
  end
  
end
