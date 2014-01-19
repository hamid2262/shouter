module UsersHelper

	def follow_button user, klass = "btn btn-default"
		if current_user.following? user
			button_to t('profiles.unfollow'), user_follow_path(user), method: :delete, class: "btn btn-success"
		else
			button_to t('profiles.follow'), user_follow_path(user), class: "#{klass}"			
		end
	end

	def user_form_control_static title, field_value
		field_value = t('no_data') if field_value.blank?
		html = <<-HTML
		  <div class="form-group">
		    <label class="col-sm-3 control-label">#{title}</label>
		    <div class="col-sm-9">
		      <p class="form-control-static">
						#{field_value}
		      </p>
		    </div>
		  </div>
		HTML
		html.html_safe 
	end
end

