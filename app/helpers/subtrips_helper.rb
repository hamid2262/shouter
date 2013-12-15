module SubtripsHelper

	def find_user_obj id
		User.find_by(id: id)
	end
	
	def check_for_seat_state id, index
		result = case id 
		when -1
			"#{index+1}   =>  unavailable "
		when  0
			"#{index+1} => available #{check_box_tag("seat_numbers[#{index}][]", "T")} "
		when  current_user.id
			"#{index+1} => Your seat #{check_box_tag("seat_numbers[#{index}][]", "T", true)} "
		else
			"#{index+1}   =>  taken  #{find_user_obj(id).name}  "
		end

		"<li> #{result} </li>".html_safe
	end
	
end
