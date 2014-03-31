module BookingsHelper
	
	def status_indicator status
		if status == 0
			content_tag(:button, t("waiting"), class: "btn  btn-sm btn-warning status_indicator", disabled: "disabled")
		elsif status == 1
			content_tag(:button,t("accepted"), class: "btn  btn-sm btn-success status_indicator", disabled: "disabled")
		elsif status == -1
			content_tag(:button,t("rejected"), class: "btn  btn-sm btn-danger status_indicator", disabled: "disabled")				
		end
	end

	def check_for_seat_state id, index
		user = User.find(id) if id > 0
		result = case id 
		when -1
			" <th> #{index+1} </th>   
  			<th class=\"not_available\"> #{t 'not_available'} </th>
  		"
		when  0
			" <th> #{index+1} </th>   
			<input type=\"hidden\"  name=\"seat_numbers[#{index}]\" value=\"F\" />
			<th> <input type=\"checkbox\" id=\"seat_numbers_#{index}\" name=\"seat_numbers[#{index}]\" value=\"T\" />	</th>
			"
		else
			" <th> #{index+1} </th>   
  			<th> #{link_to user.name, profile_url(user)}	</th>

			"
		end

		"#{result}".html_safe
	end

end
