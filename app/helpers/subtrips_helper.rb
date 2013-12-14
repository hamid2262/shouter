module SubtripsHelper

	def find_user_obj id
		User.find_by(id: id)
	end
	
	def check_for_seat_state id, index
		result = if id == -1
			"#{index}   =>  unavailable "
		elsif id == 0
			"#{index} => available #{check_box_tag('seat_number[]', index+1)} "
		else
			"#{index}   =>  taken  #{find_user_obj(id).name}  "
		end
		"<li> #{result} </li>".html_safe
	end
	
end
