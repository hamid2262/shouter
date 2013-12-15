module SubtripsHelper

	def find_user_obj id
		User.find_by(id: id)
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


				#{hidden_field_tag("seat_numbers[#{index}][]", "F")}
				#{check_box_tag("seat_numbers[#{index}][]", "T", true)} 
			
			#{check_box_tag("seat_numbers[#{index}]", "T")} 
			#{hidden_field_tag("seat_numbers[#{index}]", "F")}	