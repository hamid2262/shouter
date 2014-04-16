class Home

	def self.newtrips
    subtrips = Subtrip.where.not("origin_address = destination_address").where("active = true")
    subtrips = subtrips.where("date_time > ?", DateTime.now)
    subtrips = subtrips.where("created_at > ?", DateTime.now - 4.days)
    subtrips = subtrips.order(date_time: :desc)		
	end

	def self.spacial_events
		SpacialEvent.where("end_date > ?", Date.today-1.day)
	end

end