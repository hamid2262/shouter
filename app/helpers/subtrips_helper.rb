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
			"<strong class=\"text-danger\"><h3>#{s.origin} </h3> #{s.date_time.to_s(:time)} </strong>".html_safe			
		else
			"#{s.origin}  <b>#{s.date_time.to_s(:time)}</b>".html_safe		
		end
	end

	def print_last_city_name s, current_s
		if s.destination == current_s.destination
			"<b class=\"text-danger\"><h3>#{s.destination} </h3> #{s.date_time.to_s(:time)} </b>".html_safe					
		else
			s.destination			
		end
	end

	def check_for_seat_state id, index
		result = case id 
		when -1
			# "#{index+1}   =>  #{t('.taken')} 
			# 	<input type=\"hidden\"   name=\"seat_numbers[#{index}]\" value=\"-1\" />
			# "
		when  0
			" <th> #{index+1} </th>   
			<input type=\"hidden\"   name=\"seat_numbers[#{index}]\" value=\"F\" />
			<th> <input type=\"checkbox\" id=\"seat_numbers_#{index}\" name=\"seat_numbers[#{index}]\" value=\"T\" />	</th>
			"
		when  current_user.id
			# "#{index+1} => Your seat 
			# 	<input type=\"hidden\"   name=\"seat_numbers[#{index}]\" value=\"F\" />
			# 	<input type=\"checkbox\" name=\"seat_numbers[#{index}]\" value=\"T\" checked=\"checked\" />	
			# "
		else
			# "#{index+1}   =>  taken  #{find_user_obj(id).name} 
			# 	<input type=\"hidden\" name=\"seat_numbers[#{index}]\" value=\"#{find_user_obj(id).id}\" />
			# "
		end

		"#{result}".html_safe
	end
	
end