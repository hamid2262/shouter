class SearchSubtrip 
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
	attr_accessor :origin_id, :origin_lat, :origin_lng, :origin_cycle, 
								:destination_id, :destination_lat, :destination_lng, :destination_cycle, 
								:date, :jday, :jmonth, :jyear,
								:search_form_type

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
		origin_ids = cities_near_origin.map { |d| d.id }
		destination_ids = cities_near_destination.map { |d| d.id }

		# start_date = DateTime.parse(date) 
		# end_date = start_date.end_of_day + days.days
	  subtrips = Subtrip.where("origin_id IN (?)", origin_ids ) 
	  subtrips.where("destination_id IN (?)", destination_ids ) 

	  # , destination_id: destination_id)
		# subtrips.where("date_time > ?", start_date).where("date_time < ?", end_date)		
		# subtrips = Subtrip.all
	end

	def make_jdateـfor_search session, params
		if self && self.date && session == 'autocomplete'
			self.date = JalaliDate.new(self.date)

		elsif self  && session == 'select' && (params.nil? || params[:jday].nil? )
			self.jday = JalaliDate.new(Date.today).day			
			self.jmonth = JalaliDate.new(Date.today).month			
			self.jyear = JalaliDate.new(Date.today).year			
		end	end

	private
		def cities_near_origin
			City.near([origin_lat,origin_lng], 1 + origin_cycle.to_f/1.609344 )
		end

		def cities_near_destination
			City.near([destination_lat,destination_lng],1 + destination_cycle.to_f/1.609344 )
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
end