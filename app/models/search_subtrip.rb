class SearchSubtrip 
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
	attr_accessor :origin_id, :origin_lat, :origin_lng, :origin_cycle, 
								:destination_id, :destination_lat, :destination_lng, :destination_cycle, 
								:date, :jday, :jmonth, :jyear,
								:search_form_type

	validates :destination_id, presence: true
	validates :origin_id, presence: true
	validate :jday, :jday_validate

	def initialize attributes ={}
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
    Subtrip.all
  end

	def subtrips days=0
		if self.destination_lat.present? && self.origin_lat.present?
			origin_ids = cities_near_latlng(self.origin_lat, self.origin_lng, self.origin_cycle).map { |d| d.id } 
			destination_ids = cities_near_latlng(self.destination_lat, self.destination_lng, self.destination_cycle).map { |d| d.id } 
		elsif self.destination_id.present? && self.origin_id.present?			
			origin_ids = cities_near_cityid(self.origin_id, origin_cycle).map { |d| d.id }
			destination_ids = cities_near_cityid(self.destination_id, destination_cycle).map { |d| d.id }
		end

		if self.jday.present?

				start_date = JalaliDate.new(jyear.to_i,jmonth.to_i,jday.to_i).to_gregorian.beginning_of_day - 1.minute				

		elsif self.date.present?
			start_date = JalaliDate.new(date).to_gregorian.beginning_of_day - 1.minute
		end

		end_date = start_date.end_of_day + days.days

	  subtrips = Subtrip.where("origin_id IN (?) AND destination_id IN (?)", origin_ids, destination_ids ) 
	  # subtrips.where("destination_id IN (?)", destination_ids ) 			
		subtrips.where("date_time > ?", start_date).where("date_time < ?", end_date)
	end

	def make_jdateـfor_search params
		if self  && (params.nil? || params[:jday].nil? )
			self.jday = JalaliDate.new(Date.today).day			
			self.jmonth = JalaliDate.new(Date.today).month			
			self.jyear = JalaliDate.new(Date.today).year			
		end	
	end

	private
		def cities_near_latlng lat, lng, cycle
			City.near([lat,lng], 1 + cycle.to_f/1.609344 )
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
end