class Booking < ActiveRecord::Base
  belongs_to :passenger, class_name: "User", foreign_key: "user_id"
  belongs_to :subtrip

  delegate :trip, :to => :subtrip, :allow_nil => true
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

  def update_all_bookings
    all_crossed_subtrips = self.subtrip.find_conflict_subtrips 

    seat_numbers = self.find_seat_numbers self.subtrip, self

    all_crossed_subtrips.each do |subtrip|
      seats = create_replacing_seats_array_for_delete(subtrip)
      save_new_seats_array(seats, subtrip)
    end
    
    if check_if_subtrips_dirty_after_delete(seat_numbers)
      subs = subtrips_of_trip self
      subs.each do |subtrip|
        subtrip.bookings.where("acceptance_status  > -1").each do |b|
          seats_indexes = b.subtrip.seats.each_index.select{|i| b.subtrip.seats[i] == b.passenger.id}
          
          # seat_numbers = find_seat_numbers b.subtrip, b
          
          all_crossed_subtrips = b.subtrip.find_conflict_subtrips 

          all_crossed_subtrips.each do |s|
            seats_indexes.each do |i|
              s.seats[i] = b.passenger.id
            end
            save_new_seats_array(s.seats, s)
          end

        end
      end
    end
    # set all acceptance_status  of bookings from the  same passenger to -1
    self.subtrip.bookings.where(user_id: self.passenger.id).each { |e| e.update_attributes(acceptance_status: -1) }
  end

  def check_if_subtrips_dirty_after_delete seat_numbers
    flag = false
    subs = subtrips_of_trip self
    seat_numbers.each do |s_index|
      subs.each do |subtrip|
        if subtrip.seats[s_index] != 0
          flag = true
        end
      end
    end 
    flag
  end

  def subtrips_of_trip booking
    Subtrip.find(booking.subtrip.id).trip.subtrips
  end

  def find_seat_numbers subtrip, booking
    subtrip.seats.each_index.select{|i| subtrip.seats[i] == booking.passenger.id}
  end

  def booking_id_check hashed_code
    if hashed_code     ==  Digest::MD5.hexdigest("yes#{self.id}")
      self.acceptance_status = 1
      self.save
      1
    elsif  hashed_code ==  Digest::MD5.hexdigest("no#{self.id}")
      self.acceptance_status = -1
      self.save
      -1
    else
      false
    end
  end

  private
    def save_new_seats_array(seats, subtrip)
        subtrip.seats = []
        seats.each do |single|
          subtrip.seats << single
        end
        subtrip.save    
    end

    def create_replacing_seats_array_for_delete subtrip, num = 0
        seats = subtrip.seats
        seats.collect! { |element|
         (element == self.passenger.id) ? num : element
        }
    end


end
