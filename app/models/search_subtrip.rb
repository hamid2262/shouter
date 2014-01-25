class SearchSubtrip 
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
	attr_accessor :origin_id, :origin_name, :origin_lat, :origin_lng, :origin_cycle, 
								:destination_id, :destination_name, :destination_lat, :destination_lng, :destination_cycle, 
								:date, :jday, :jmonth, :jyear,
								:autocomplete
	

	validate :cities_cannot_be_blank
	validate :jday, :jday_validate
	before_validation :check_for_cities_validation

	def initialize attributes ={}
			@jday ||= JalaliDate.new(Date.today).day 
			@jmonth ||= JalaliDate.new(Date.today).month 
			@jyear ||= JalaliDate.new(Date.today).year
  		@origin_cycle ||= 20
  		@destination_cycle ||= 20
    unless attributes.nil?
      attributes.each do |name, value|
        send("#{name}=", value)
      end
  		@date = convert_jalali_to_gregorian( attributes.fetch(:date, "") )
    end
	end

  def persisted?
    false
  end

	def self.inspect
	  "#<#{ self.to_s} #{ self.attributes.collect{ |e| ":#{ e }" }.join(', ') }>"
	end

  def self.all
    Subtrip.where.not("origin_id = destination_id").order(date_time: :desc)
  end

  def subtrips_close_to_user ip, cycle = 100
  	 lat = Geocoder.search(ip).first.latitude 
  	 lng = Geocoder.search(ip).first.longitude
  	 city_ids = city_ids_near_latlng lat, lng, cycle
	   subtrips = Subtrip.where("origin_id IN (?)", city_ids ) 
		 subtrips = subtrips.concat( Subtrip.where("destination_id IN (?)", city_ids ) )
  end

	def subtrips days=0
		if self.destination_lat.present? && self.origin_lat.present?
			origin_ids = city_ids_near_latlng(self.origin_lat, self.origin_lng, self.origin_cycle) 
			destination_ids = city_ids_near_latlng(self.destination_lat, self.destination_lng, self.destination_cycle) 
		elsif self.destination_id.present? && self.origin_id.present?			
			origin_ids = cities_near_cityid(self.origin_id, origin_cycle).map { |d| d.id }
			destination_ids = cities_near_cityid(self.destination_id, destination_cycle).map { |d| d.id }
		end

		start_date = JalaliDate.new(jyear.to_i,jmonth.to_i,jday.to_i).to_gregorian.beginning_of_day - 1.minute
		end_date = start_date.end_of_day + days.days

	  subtrips = Subtrip.where("origin_id IN (?) AND destination_id IN (?)", origin_ids, destination_ids ) 
		subtrips.where("date_time > ?", start_date).where("date_time < ?", end_date)
	end

	private
		def city_ids_near_latlng lat, lng, cycle
			cities = City.near([lat,lng], 1 + cycle.to_f/1.609344 )
			 origin_ids = cities.map{|c| c.id}
		end

		def cities_near_destination_latlng
			City.near([destination_lat,destination_lng],1 + destination_cycle.to_f/1.609344 )
		end

		def cities_near_cityid city_id, cycle
			city = City.find(city_id)
			City.near(city, 1 + cycle.to_f/1.609344 )
		end

		def convert_jalali_to_gregorian date
			date = date.split("/").reverse
			if (date[0].to_i > 1391 && date[0].to_i <= 1400) && 
				 (date[1].to_i > 0 && date[1].to_i <= 12) && 
				 (date[2].to_i > 0  && date[2].to_i < 32)
				date_obj = JalaliDate.new( date[0].to_i, date[1].to_i, date[2].to_i )
			else
				date_obj = JalaliDate.new(Date.today)
			end
			date = date_obj.to_g
		end

		def jday_validate
			if self.jmonth.to_i > 6 && jday.to_i > 30 ||
			   self.jmonth.to_i == 12 && jday.to_i > 29
				errors.add(:jday, "Day is not a valid day")
			end
		end

		def check_for_cities_validation
			if self.autocomplete == "true"
				if self.origin_lat.blank? && self.origin_name
					if Geocoder.search(self.origin_name)[0].try(:latitude).present?
						self.origin_lat = Geocoder.search(self.origin_name)[0].latitude
						self.origin_lng = Geocoder.search(self.origin_name)[0].longitude
						self.origin_name = Geocoder.search(self.origin_name)[0].address
					end
				end
				if self.destination_lat.blank? && self.destination_name
					if Geocoder.search(self.destination_name)[0].try(:latitude).present?  
						self.destination_lat = Geocoder.search(self.destination_name)[0].latitude
						self.destination_lng = Geocoder.search(self.destination_name)[0].longitude
						self.destination_name = Geocoder.search(self.destination_name)[0].address
					end
				end				
			end
		end

		def cities_cannot_be_blank
			if @autocomplete == "true"
				errors.add(:origin_name, "can't be blank")	if @origin_name.blank?		
				errors.add(:destination_name, "can't be blank")	if @destination_name.blank?		
			else
				errors.add(:origin_id, "can't be blank")	if @origin_id.blank?		
				errors.add(:destination_id, "can't be blank")	if @destination_id.blank?					
			end
		end

end