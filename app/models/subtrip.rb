class Subtrip < ActiveRecord::Base

  attr_accessor  :jalali_year, :jalali_month, :jalali_day, :jalali_hour, :jalali_minute
  
  before_save { |subtrip| subtrip.date_time = provide_date_time_from_jalali(subtrip) }
  belongs_to :trip
  belongs_to :origin, class_name: "City", foreign_key: "origin_id"
  belongs_to :destination, class_name: "City", foreign_key: "destination_id"
  has_many	 :bookings

  # validates :jalali_minute, presence: true
  
  default_scope { order('date_time ASC') } 

  def jalali_year
    JalaliDate.new(date_time).year if date_time.present?
  end

  def jalali_year=(jyear)
    self.date_time.year = JalaliDate.new(1388,11,1).g_day
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

  private 

    def provide_date_time_from_jalali s
      # jdate = JalaliDate.new(s.date_time - s.jalali_day.day)
      # jdate.to_g      
    end

    def  find_before_and_after_origin_conflict_subtrips origin, destination, subtrips
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
end
