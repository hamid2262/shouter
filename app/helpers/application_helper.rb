module ApplicationHelper
	
	def table_show_cell(title, value)
		value = 'No Data' if value.blank?
		"<tr> 
				<th>
						#{title}
				</th>
				<td>
						#{value} 
				</td>
			</tr>".html_safe #unless value.blank?
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
    link_to(name, '#', class: "add_fields btn btn-default btn-sm", data: {id: id, fields: fields.gsub("\n", "")})
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
  
  def jalali_date s
    JalaliDate.new(s).strftime("%A  %d %b %Y")
  end
 
  def jalali_time s
    JalaliDate.new(s).strftime("%I:%M - %p")
  end

# Date picker for jalali
	def options_for_year 
		options_for_select( 1392..1393, JalaliDate.new(Date.today).year)
	end

	def collection_for_month #used in search form
	[ 
		['فروردین', 1], ['اردیبهشت', 2], 
		['خرداد', 3], ['تیر', 4], 
		['مرداد', 5], ['شهریور', 6], 
		['مهر', 7], ['آبان', 8], 
		['آذر', 9], ['دی', 10], 
		['بهمن', 11], ['اسفند', 12] 
	]	

	end		 

	def options_for_month #used in insert trip
		options_for_select(	[ 
			['فروردین', 1], ['اردیبهشت', 2], 
			['خرداد', 3], ['تیر', 4], 
			['مرداد', 5], ['شهریور', 6], 
			['مهر', 7], ['آبان', 8], 
			['آذر', 9], ['دی', 10], 
			['بهمن', 11], ['اسفند', 12] 
		]	, JalaliDate.new(Date.today).month)		
	end		 

	def options_for_day
		options_for_select(1..31 , JalaliDate.new(2.days.from_now).day)		
	end		 

	def options_for_hour
		options_for_select ("00".."24")
	end		 

	def options_for_minute
		options_for_select ['00','15','30','45']
	end	
	
end