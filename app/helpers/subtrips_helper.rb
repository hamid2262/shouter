module SubtripsHelper

	def find_user_obj id
		User.find_by(id: id)
	end
	
	def full_style subtrip
		if subtrip.free_seats == 0
	    full_style = "background: #E5EBEE;opacity: .5;"
 		end		
	end
	
	def print_cities_name s, current_s
		if (s.origin == current_s.origin) || (s.origin == current_s.destination)
			"<strong class=\"text-danger\"><h3>#{s.origin(locale)} </h3> #{s.date_time.to_s(:time)} </strong>".html_safe			
		else
			"#{s.origin}  <b>#{s.date_time.to_s(:time)}</b>".html_safe		
		end
	end

	def print_last_city_name s, current_s
		if s.destination == current_s.destination
			"<b class=\"text-danger\"><h3>#{s.destination(locale) } </h3> #{s.date_time.to_s(:time)} </b>".html_safe					
		else
			s.destination			
		end
	end

end