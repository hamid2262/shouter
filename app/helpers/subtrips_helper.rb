module SubtripsHelper

	def find_user_obj id
		User.find_by(id: id)
	end
	
	def print_cities_name s, current_s
		if (s.origin == current_s.origin) || (s.origin == current_s.destination)
			"<b class=\"text-danger\">#{s.origin.local_name}  </b>".html_safe			
		else
			"#{s.origin.local_name}  (#{s.date_time.to_s(:time)})"		
		end
	end

	def print_last_city_name s, current_s
		if s.destination == current_s.destination
			"<b class=\"text-danger\">#{s.destination.local_name} </b>".html_safe			
		else
			s.destination.local_name			
		end
	end

	def check_for_seat_state id, index
		result = case id 
		when -1
			"#{index+1}   =>  unavailable 
				<input type=\"hidden\"   name=\"seat_numbers[#{index}]\" value=\"-1\" />
			"
		when  0
			"#{index+1} => available 
			<input type=\"hidden\"   name=\"seat_numbers[#{index}]\" value=\"F\" />
			<input type=\"checkbox\" name=\"seat_numbers[#{index}]\" value=\"T\" />	
			"
		when  current_user.id
			"#{index+1} => Your seat 
				<input type=\"hidden\"   name=\"seat_numbers[#{index}]\" value=\"F\" />
				<input type=\"checkbox\" name=\"seat_numbers[#{index}]\" value=\"T\" checked=\"checked\" />	
			"
		else
			"#{index+1}   =>  taken  #{find_user_obj(id).name} 
				<input type=\"hidden\"   name=\"seat_numbers[#{index}]\" value=\"#{find_user_obj(id).id}\" />
			"
		end

		"<li> #{result} </li>".html_safe
	end
	
end