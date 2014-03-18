class Home

	def self.newtrips
    subtrips = Subtrip.where.not("origin_address = destination_address")
    subtrips = subtrips.where("date_time > ?", DateTime.now)
    subtrips = subtrips.order(date_time: :desc)		
	end

	def self.spacial_events
		SpacialEvent.where("end_date > ?", Date.today-1.day)
	end

end