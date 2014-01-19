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
end
