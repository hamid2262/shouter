class Subtrip < ActiveRecord::Base
  belongs_to :trip
  belongs_to :origin, class_name: "City", foreign_key: "origin_id"
  belongs_to :destination, class_name: "City", foreign_key: "destination_id"
  has_many	 :bookings

  default_scope { order('date_time ASC').order(:id) } 

  validate  :jday,   :jday_validate
  validate  :jdate_must_not_be_past


  validates :origin_id, presence: true
  validates :jminute, presence: true
  validates :jhour, presence: true

  before_create :set_seats
  before_create :set_date_time
 
  def number_of_taken_seats
    self.seats.size - ( self.seats.count(0) + self.seats.count(-1) )
  end

  def self.number_of_requested_seats subtrip_id, passenger_id
    Subtrip.find(subtrip_id).seats.count passenger_id
  end

  def vehicle_type
    case self.seats.size
    when 1..4 
      "car"
    when 5..9 
      "van"
    when 10..20 
      "minibus"
    when 21..60 
      "bus"
    end
  end

  # used in seats_order
  def is_waiting_for? user_id
    flag = true
    con_subs = self.find_conflict_subtrips  
    con_subs.each do |con_sub|
      if  b=con_sub.bookings.where(user_id: user_id).last
        if b.acceptance_status != 0
          flag = false
        end
      end
    end
    flag
  end

  def find_conflict_subtrips
  	origin = self.origin_id
    destination = self.destination_id
    subtrips = self.trip.subtrips

    before_subtrip = find_before_and_after_origin_conflict_subtrips origin, destination, subtrips
    after_subtrip  = find_before_and_after_destination_conflict_subtrips origin, destination, subtrips
    inbetween_subtrip  = find_inbetween_origin_and_destination_conflict_subtrips origin, destination, subtrips

    all_conflict_subtrips = (inbetween_subtrip + before_subtrip + after_subtrip).uniq
  end

  def find_before_and_after_origin_conflict_subtrips origin, destination, subtrips
    before_and_itself_cities = self.trip.before_and_itself_cities origin
    after_cities = self.trip.after_cities origin
    subtrips.where(origin_id: before_and_itself_cities, destination_id: after_cities) 	
  end

  def find_before_and_after_destination_conflict_subtrips origin, destination, subtrips
    before_cities = self.trip.before_cities destination
    after_and_itself_cities = self.trip.after_and_itself_cities destination
    subtrips.where(origin_id: before_cities, destination_id: after_and_itself_cities)  	
  end

  def find_inbetween_origin_and_destination_conflict_subtrips origin, destination, subtrips
    inbetween_cities = self.trip.inbetween_cities origin, destination    
    subtrips.where(origin_id: inbetween_cities, destination_id: inbetween_cities)  	
  end

  private

    def jdate_must_not_be_past

      if JalaliDate.new(self.jyear, self.jmonth, self.jday ) < JalaliDate.new(Date.today) 
        errors.add(:jday, :invalid_date)   
        errors.add(:jmonth, :invalid_date)   
        errors.add(:jyear, :invalid_date)   
      end
      
    end

    def jday_validate
      if self.jmonth.to_i > 6 && jday.to_i > 30 ||
         self.jmonth.to_i == 12 && jday.to_i > 29
        errors.add(:jday, "Day is not a valid day")
      end
    end

    def set_seats
      s = []
      for i in 0..(self.trip.total_available_seats-1) do
        s << 0
      end
      self.seats = s
    end

    def set_date_time    
      jdate = JalaliDate.new(self.jyear,self.jmonth,self.jday)  
      gdate = jdate.to_g
      self.date_time = gdate + self.jhour.hours + self.jminute.minutes
    end
end
