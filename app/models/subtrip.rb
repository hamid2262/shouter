class Subtrip < ActiveRecord::Base
  # geocoded_by :origin_address, latitude: :olat, longitude: :olng
  geocoded_by :destination_address, latitude: :dlat, longitude: :dlng

  belongs_to :trip
  has_many	 :bookings

  default_scope { order('date_time ASC').order(:id) } 

  validate  :jday,   :jday_validate
  validate  :jdate_must_not_be_past

  validates :origin_address, length: {minimum: 2}, allow_blank: true
  validates :olat, presence: true
  validates :olng, presence: true
  
  validates :jminute, presence: true, unless: 'origin_address.nil?'
  validates :jhour, presence: true

  before_validation :check_for_cities_validation
  before_create :set_seats
  before_create :set_date_time
  before_save :split_address_to_city_state_country
 
  def origin
    city = self.origin_address unless self.origin_address.blank?
    city = self.origin_country unless self.origin_country.blank?
    city = self.origin_state unless self.origin_state.blank?
    city = self.origin_city unless self.origin_city.blank?
    city 
  end

  def destination
    city = self.destination_address unless self.destination_address.blank?
    city = self.destination_country unless self.destination_country.blank?
    city = self.destination_state unless self.destination_state.blank?
    city = self.destination_city unless self.destination_city.blank?    
    city
  end

  def number_of_taken_seats
    self.seats.size - ( self.seats.count(0) + self.seats.count(-1) )
  end

  def number_of_total_seats
    self.seats.size + self.seats.count(-1)
  end

  def free_seats
    self.seats.count(0)    
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
  	origin = self.origin_address
    destination = self.destination_address
    subtrips = self.trip.subtrips

    before_subtrip = find_before_and_after_origin_conflict_subtrips origin, destination, subtrips
    after_subtrip  = find_before_and_after_destination_conflict_subtrips origin, destination, subtrips
    inbetween_subtrip  = find_inbetween_origin_and_destination_conflict_subtrips origin, destination, subtrips
    all_conflict_subtrips = (inbetween_subtrip + before_subtrip + after_subtrip).uniq
  end

  def find_before_and_after_origin_conflict_subtrips origin, destination, subtrips
    before_and_itself_cities = self.trip.before_and_itself_cities origin
    after_cities = self.trip.after_cities origin
    subtrips.where(origin_address: before_and_itself_cities, destination_address: after_cities) 	
  end

  def find_before_and_after_destination_conflict_subtrips origin, destination, subtrips
    before_cities = self.trip.before_cities destination
    after_and_itself_cities = self.trip.after_and_itself_cities destination
    subtrips.where(origin_address: before_cities, destination_address: after_and_itself_cities)  	
  end

  def find_inbetween_origin_and_destination_conflict_subtrips origin, destination, subtrips
    inbetween_cities = self.trip.inbetween_cities origin, destination    
    subtrips.where(origin_address: inbetween_cities, destination_address: inbetween_cities)  	
  end

  private

    def jdate_must_not_be_past
      if self.jyear
        if JalaliDate.new(self.jyear, self.jmonth, self.jday ) < JalaliDate.new(Date.today) 
          errors.add(:jday, :invalid_date)   
          errors.add(:jmonth, :invalid_date)   
          errors.add(:jyear, :invalid_date)   
        end
      else
        if self.date_time < DateTime.now 
          errors.add(:date_time, :invalid_date)  
        end   
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
      if date_time.nil?
        jdate = JalaliDate.new(self.jyear,self.jmonth,self.jday)  
        gdate = jdate.to_g
      else
        gdate = self.date_time
      end
      self.date_time = gdate + self.jhour.hours + self.jminute.minutes
    end

    def check_for_cities_validation
      if self.olat.blank? && self.origin_address
        origin = Geocoder.search(self.origin_address)[0]
        if origin.try(:latitude).present?
          self.olat                = origin.latitude
          self.olng                = origin.longitude
          self.origin_city         = origin.city
          self.origin_state        = origin.state
          self.origin_country      = origin.country
          self.origin_country_code = origin.try(:country_code)
        end
      end
      if self.dlat.blank? && self.destination_address
        destination = Geocoder.search(self.destination_address)[0]
        if destination.try(:latitude).present?  
          self.dlat                = destination.latitude
          self.dlng                = destination.longitude
          self.destination_city    = destination.city
          self.destination_state   = destination.state
          self.destination_country = destination.country
        end
      end       
    end

    def split_address_to_city_state_country
      if self.origin_address && (self.origin_address.include? ",")
        origin = Geocoder.search(self.origin_address)[0]
        address = self.origin_address.split(',')
        self.origin_country = address[-1] 
        self.origin_state = address[-2]   
        self.origin_city = address[-3]    
        self.origin_country_code = origin.try(:country_code) unless origin.try(:country_code).blank?
      end

      if self.destination_address && (self.destination_address.include? ",")
        destination = Geocoder.search(self.destination_address)[0]        
        address = self.destination_address.split(',')
        self.destination_country = address[-1] 
        self.destination_state = address[-2]   
        self.destination_city = address[-3]    
      end

    end
end
