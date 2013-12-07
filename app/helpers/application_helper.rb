module ApplicationHelper
	
	def table_show_cell(title, value)
		"<tr> 
				<th>
						#{title}
				</th>
				<td>
						#{value} 
				</td>
			</tr>".html_safe unless value.blank?
	end

	def map_address(address, zoom = 9)
		if address.longitude.present?
		  image_tag "http://maps.googleapis.com/maps/api/staticmap?center= #{address.latitude},#{address.longitude}&zoom=11&#{address.latitude},#{address.longitude}&size=600x400&sensor=false"

		else
		  "Address is not accessable"
		end
					
		end
end