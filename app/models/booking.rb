class Booking < ActiveRecord::Base
  belongs_to :passenger, class_name: "User", foreign_key: "user_id"
  belongs_to :subtrip

  # after_destroy :release_subtrip_seats

  def self.create_new_seats_array params, current_user, subtrip
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

  def get_all_conflict_seats seat_numbers
    all_crossed_subtrips = self.subtrip.find_conflict_subtrips 

    all_crossed_subtrips.each do |subtrip|
      updated_seats(subtrip, seat_numbers, self.passenger) 
    end
  end

  private

    def updated_seats subtrip, seat_numbers, passenger
      seats = subtrip.seats
      seat_numbers.each do |k,v|
        if v == 'T'
          seats[k.to_i] = passenger.id
        end
      end
      subtrip.seats = []
      seats.each do |single|
        subtrip.seats << single
      end
      subtrip.save
    end

end
