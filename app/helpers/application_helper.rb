module ApplicationHelper

	def lang_side
		params[:locale] == 'fa' ? "right" : "left"
	end

	def lang_other_side
		params[:locale] == 'fa' ? "left" : "right"
	end

	def t_gender gender
		if gender == 'm'
			t('gender.male')
		else
			t('gender.female')
		end
	end
	
	def mailer_profile_url user
		profile_url(id: user.slug, locale: locale)
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
				alt:"#{user.name}", class: klass )
		elsif user.facebook_image_url.present?
			image_tag(user.facebook_image_url, 
				size: "#{size}x#{size}", 
				alt:"#{user.name}", class: klass )		
		else
			image_tag(default_avatar(user), 
				size: "#{size}x#{size}", 
				alt:"#{user.name}", class: klass )

				# gravatar_image_tag( user.email.gsub('spam', 'mdeering'), 
				# 	:alt => "#{user.name}", 
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
  
	def currency price
		number_to_currency(price, delimiter: ",", format: "%n",precision: 0)
	end

  def jdate_humanize_without_today date_time
		if params[:locale] == 'fa'
  		jalali_date date_time
  	else
  		date_time.strftime("%d %b %Y")
  	end
  end

  def jday_humanize date_time
  	if params[:locale] == 'fa'
  		jalali_day date_time
  	else
  		date_time.strftime("%A")
  	end
  end

  def jtime_humanize date_time
  	if params[:locale] == 'fa'
  		jalali_time(date_time)
  	else
  		date_time.strftime("%I:%M %p")
  	end
  end  

	def before_after time
		if time <= Time.now
      t('before')
		else
			t('after')
		end
	end

	def am_pm time
		if time.hour >= 12
      t('time.pm')
		else
			t('time.am')
		end
	end

  def jdate_humanize date_time
  	if date_time.to_date == Date.today
  		t "today"
  	elsif date_time.to_date == Date.today + 1.day
  		t "tomorrow"
  	elsif params[:locale] == 'fa'
  		jalali_date date_time
  	else
  		date_time.strftime("%d %b %Y")
  	end
  end

	def apropriate_date subtrip
		if subtrip.origin_country_code == "IR" && (locale == :fa)
	    JalaliDate.new(subtrip.date_time).strftime("%d %b %Y")
		else
			I18n.l subtrip.date_time, format: :my_date 		
		end
	end

	def apropriate_date_humanize subtrip
  	if subtrip.date_time.to_date == Date.today
  		t "today"
  	elsif subtrip.date_time.to_date == Date.today + 1.day
  		t "tomorrow"
		elsif subtrip.origin_country_code == "IR" && (locale == :fa)
	    JalaliDate.new(subtrip.date_time).strftime("%d %b %Y")
		else
			I18n.l subtrip.date_time, format: :my_date 		
		end
	end

  def jalali_date s
    JalaliDate.new(s).strftime("%d %b %Y")
  end

  def jalali_day s
    JalaliDate.new(s).strftime("%A")
  end
 
  def jalali_time s
    JalaliDate.new(s).strftime("%H:%M")
  end

  # Date picker for jalali
	def options_for_year 
		options_for_select( 1393..1393, JalaliDate.new(Date.today).year)
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
			['فروردین', 1], 
			['اردیبهشت', 2], 
			['خرداد', 3], 
			['تیر', 4], 
			['مرداد', 5], 
			['شهریور', 6], 
			['مهر', 7], 
			['آبان', 8], 
			['آذر', 9], 
			['دی', 10], 
			['بهمن', 11], 
			['اسفند', 12] 
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

  def notification_exist? notification
  	(notification && notification > 0) ? true : false
  end

end