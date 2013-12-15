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

	def subtrips
		Subtrip.where(origin_id: origin_id, destination_id: destination_id)#, date: date)
	end

	private

end