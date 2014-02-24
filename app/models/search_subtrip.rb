class SearchSubtrip 
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
	attr_accessor :origin_address, :olat, :olng, :origin_cycle, 
								:destination_address, :dlat, :dlng, :destination_cycle, 
								:date, :jday, :jmonth, :jyear

	# validate :cities_cannot_be_blank
	validate :jday, :jday_validate
	before_validation :check_for_cities_validation

	def cycle_range
		[5,10,25,50,100,200]
	end

	def initialize attributes ={}
			@jday ||= JalaliDate.new(Date.today).day 
			@jmonth ||= JalaliDate.new(Date.today).month 
			@jyear ||= JalaliDate.new(Date.today).year
  		@origin_cycle ||= 25
  		@destination_cycle ||= 25
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

	def newtrips
    subtrips = Subtrip.where.not("origin_address = destination_address")
    subtrips = subtrips.where("date_time > ?", DateTime.now)
    subtrips = subtrips.order(date_time: :desc)		
	end

  def subtrips_close_to_user ip, cycle = 100
  	 lat = Geocoder.search(ip).first.latitude 
  	 lng = Geocoder.search(ip).first.longitude
  	#  city_ids = city_ids_near_latlng lat, lng, cycle
	  #  subtrips = Subtrip.where("origin_id IN (?)", city_ids ) 
		 # subtrips = subtrips.concat( Subtrip.where("destination_id IN (?)", city_ids ) )
  end

	def subtrips days=0
		start_date = JalaliDate.new(jyear.to_i,jmonth.to_i,jday.to_i).to_gregorian.beginning_of_day - 1.minute
		end_date = start_date.end_of_day + days.days

		subtrips = Subtrip.where("date_time > ?", start_date).where("date_time < ?", end_date)
		subtrips = subtrips.near(self.destination_address, self.destination_cycle , :units => :km) unless self.destination_address.blank?
	  subtrips = where_near_origin(subtrips,self.origin_address, self.origin_cycle) unless self.origin_address.blank?
    subtrips = subtrips.where.not("origin_address = destination_address")
	end



	private
	def where_near_origin subtrips, address, cycle
		lat,lng = Geocoder.coordinates address
		subtrips.where("olat - ? < ?", lat, cycle.to_f/80).where("olng - ? < ?", lng, cycle.to_f/80)
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
			if self.olat.blank? && self.origin_address
				if Geocoder.search(self.origin_address)[0].try(:latitude).present?
					self.olat = Geocoder.search(self.origin_address)[0].latitude
					self.olng = Geocoder.search(self.origin_address)[0].longitude
					# self.origin_name = Geocoder.search(self.origin_name)[0].address
				end
			end
			if self.dlat.blank? && self.destination_address
				if Geocoder.search(self.destination_address)[0].try(:latitude).present?  
					self.dlat = Geocoder.search(self.destination_address)[0].latitude
					self.dlng = Geocoder.search(self.destination_address)[0].longitude
					# self.destination_name = Geocoder.search(self.destination_name)[0].address
				end
			end				
		end

		# def cities_cannot_be_blank
  # 		errors.add(:destination_address, "can't be blank")	if @destination_address.blank?		
		# end

end