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

	def gravatar user, size = 48
		if user.image.present?
			image_tag(user.image,size: "#{size}x#{size}", alt:"#{user.name} in hamsafaryab.com")
		else
			gravatar_image_tag( user.email.gsub('spam', 'mdeering'), 
				:alt => "#{user.name} in hamsafaryab.com", 
				:class => '',
				:gravatar => { 
					:default => image(user),
					:size => size,
				}
			)
		end
	end

	def image user
		if (user.gender == "male")
			'http://s3.amazonaws.com/37assets/svn/765-default-avatar.png' 		
		else
			'http://primility.com/wp-content/uploads/2012/05/avatar-female.png'
		end
	end
end