class SearchSubtrip 

	include ActiveModel::Conversion
	attr_reader :origin_id,:origin_cycle, :destination_id, :destination_cycle, :date

	def initialize options ={}
		@origin_id = options.fetch(:origin_id, "")
		@origin_cycle = options.fetch(:origin_cycle, "")
		@destination_id = options.fetch(:destination_id, "")
		@destination_cycle = options.fetch(:destination_cycle, "")
		@date = options.fetch(:date, "")
	end

	def subtrips days=0
		start_date = if date < DateTime.now
			DateTime.now.beginning_of_day
		else
			DateTime.parse(date) 			
		end

		end_date = start_date.end_of_day + days.days

		subtrips = Subtrip.where(origin_id: origin_id, destination_id: destination_id)
		subtrips.where("datetime > ?", start_date).where("datetime < ?", end_date)		
	end

	private

end