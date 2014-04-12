module ProfilesHelper
	def force_to_sign_in_message
		html = <<-HTML
			<h5 class="text-center"> 
				#{t('profiles.show.force_login_message')}
				 #{link_to(t('sign_in'), new_user_session_path )}
			</h5>
		HTML
		html.html_safe
	end

	def profile_sidebar_row title, value, title_width = 4, value_width = 8
		html = <<-HTML
      <div class="row">
        <div class="col-sm-#{title_width}">
          <strong> #{title}</strong>
        </div>
        <div class="col-sm-#{value_width}">
          #{ value }
        </div>
      </div>
		HTML
		html.html_safe

	end
end
