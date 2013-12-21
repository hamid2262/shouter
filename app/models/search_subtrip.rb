class SearchSubtrip 

	include ActiveModel::Conversion
	attr_reader :origin_lat, :origin_lng, :origin_cycle, :destination_lat, 
							:destination_lng, :destination_cycle, :date

	def initialize options ={}
		@origin_lat = options.fetch(:origin_lat, "")
		@origin_lng = options.fetch(:origin_lng, "")
		@origin_cycle = options.fetch(:origin_cycle, "")
		@destination_lat = options.fetch(:destination_lat, "")
		@destination_lng = options.fetch(:destination_lng, "")
		@destination_cycle = options.fetch(:destination_cycle, "")
		@date = convert_jalali_to_gregorian( options.fetch(:date, "") )

	end

	def subtrips days=0
		# start_date = DateTime.parse(date) 
		# end_date = start_date.end_of_day + days.days
	  # subtrips = Subtrip.where(origin_id: origin_id, destination_id: destination_id)
		# subtrips.where("datetime > ?", start_date).where("datetime < ?", end_date)		
	end

	private
		def convert_jalali_to_gregorian date
			date = date.split("/").reverse
			if (date[0].to_i > 1391 && date[0].to_i <= 1400) && (date[1].to_i > 0 && date[1].to_i <= 12) && (date[2].to_i > 0  && date[2].to_i < 32)
				date_obj = JalaliDate.new( date[0].to_i, date[1].to_i, date[2].to_i )
			else
				date_obj = JalaliDate.new(Date.today)
			end
			date = date_obj.to_g
		end
end