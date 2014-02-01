class Home 

	def self.newtrips
    subtrips = Subtrip.where.not("origin_id = destination_id")
    subtrips = subtrips.where("date_time > ?", DateTime.now)
    subtrips = subtrips.order(date_time: :desc)		
	end

end