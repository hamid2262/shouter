module ApplicationHelper

	def lang_side
		params[:locale] == 'fa' ? "right" : "left"
	end

	def lang_other_side
		params[:locale] == 'fa' ? "left" : "right"
	end


	def farsi_right
		params[:locale] == 'fa' ? "pull-right" : "pull-left"
	end

	def farsi_left
		params[:locale] == 'fa' ? "pull-left" : "pull-right"
	end
	
	def t_gender gender
		if gender == 'm'
			t('gender.male')
		else
			t('gender.female')
		end
	end

	def link_to_profile user, klass="small", length = 100
		name = truncate(profile_url(user), length: length, omission: '').gsub("http://", "")		
		link_to name, profile_url(user),class: klass
	end

  def error_messages_for(object)
    render(:partial => 'application/error_messages',
      :locals => {:object => object})
  end
	
  def user_form_control_static title, field_value, klass1="col-xs-3", klass2="col-xs-9"
    field_value = t('no_data') if field_value.blank?
    html = <<-HTML
      <div class="form-group">
        <label class="#{klass1} control-label">#{title}</label>
        <div class="#{klass2}">
          <p class="form-control-static">
                                    #{field_value}
          </p>
        </div>
      </div>
    HTML
    html.html_safe 
  end

	def table_show_cell(title, value)
		value = t('no_data') if value.blank?
		html = <<-HTML
		<tr> 
			<th>
					#{title}
			</th>
			<td>
					#{value} 
			</td>
		</tr>
		HTML
		html.html_safe #unless value.blank?
	end

	def map_address(address, zoom = 9)
		if address.longitude.present?
		  image_tag "http://maps.googleapis.com/maps/api/staticmap?center= #{address.latitude},#{address.longitude}&zoom=11&#{address.latitude},#{address.longitude}&size=600x400&sensor=false"
		else
		  "Address is not accessable"
		end
					
	end

	def gravatar user, size = 48, klass = "img-circle", style = :thumb
		if user.avatar.present?
			image_tag(user.avatar.url(style), 
				size: "#{size}x#{size}", 
				alt:"#{user.name} in hamsafaryab.com", class: klass )
		else
			image_tag(default_avatar(user), 
				size: "#{size}x#{size}", 
				alt:"#{user.name} in hamsafaryab.com", class: klass )

				# gravatar_image_tag( user.email.gsub('spam', 'mdeering'), 
				# 	:alt => "#{user.name} in hamsafaryab.com", 
				# 	:class => klass,
				# 	:gravatar => { 
				# 		:default => default_avatar(user),
				# 		:size => size,
				# 	}
				# )				
		end
	end

	def default_avatar user
		IMAGES_PATH + user.gender + '_default_avatar.png'
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
				when :notice    
				  message += "<div class=\"alert alert-success\">#{msg}</div>"	
				when :warning    
				  message += "<div class=\"alert alert-warning\">#{msg}</div>"	
				when :error, :alert
				  message += "<div class=\"alert alert-danger\">#{msg}</div>"
				else
				  message += "<div class=\"alert alert-info\">#{msg}</div>"			
			end
	 	end 
	 	message.html_safe
	end
  
	def am_pm time
		if time.hour >= 12
      t('time.pm')
		else
			t('time.am')
		end
	end

	def currency price
		number_to_currency(price, delimiter: ",", format: "%n")
	end

  def jdate_humanize date_time, locale
  	if date_time.to_date == Date.today
  		t "today"
  	elsif date_time.to_date == Date.today + 1.day
  		t "tomorrow"
  	elsif locale == 'fa'
  		jalali_date date_time
  	else
  		date_time.strftime("%d %b %Y")
  	end
  end

  def jalali_date s
    JalaliDate.new(s).strftime("%d %b %Y")
  end

  def jalali_day s
    JalaliDate.new(s).strftime("%A")
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
	
  def resent_activity user, klass, pretext = ""
  	if user.online?
			"<strong><small class=\"text-success #{klass}\">Online</small></strong>".html_safe
  	else
			"<small class=\"text-muted #{klass}\">
				#{pretext} #{time_ago_in_words(user.updated_at)} #{t("ago")}
			</small>".html_safe
  	end
  end

  def obj_created_at obj, klass="activity", pretext = ""
		"<small class=\"text-muted #{klass}\">
				#{pretext} #{time_ago_in_words(obj.created_at)} #{t("ago")}
		</small>".html_safe
  end

end