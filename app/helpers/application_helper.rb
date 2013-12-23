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

	def gravatar user, size = 48, klass = "img-circle"
		if user.avatar.present?
			image_tag(user.avatar.url(:thumb), 
				size: "#{size}x#{size}", 
				alt:"#{user.name} in hamsafaryab.com", class: klass )
		else
			gravatar_image_tag( user.email.gsub('spam', 'mdeering'), 
				:alt => "#{user.name} in hamsafaryab.com", 
				:class => klass,
				:gravatar => { 
					:default => avatar(user),
					:size => size,
				}
			)
		end
	end

	def avatar user
		if (user.gender == "male")
			'http://s3.amazonaws.com/37assets/svn/765-default-avatar.png' 		
		else
			'http://primility.com/wp-content/uploads/2012/05/avatar-female.png'
		end
	end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end	

	def flash_creator flash
		message= "";
		flash.each do |name, msg| 	
			case name
				when :success    
				  message += "<div class=\"alert alert-success\">#{msg}</div>"	
				when :warning    
				  message += "<div class=\"alert alert-warning\">#{msg}</div>"	
				when :error    
				  message += "<div class=\"alert alert-danger\">#{msg}</div>"
				else
				  message += "<div class=\"alert alert-info\">#{msg}</div>"			
			end
	 	end 
	 	message.html_safe
	end
  
end