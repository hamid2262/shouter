module UsersHelper

	def follow_button user, klass = "btn btn-default"
		if current_user.following? user
			button_to t('profiles.unfollow'), user_follow_path(user), method: :delete, class: "btn btn-success"
		else
			button_to t('profiles.follow'), user_follow_path(user), class: "#{klass}"			
		end
	end

	def profile_tab_addr tab
    link_to t("navbar.profile.#{tab}"), user_refresh_path(user_id: current_user.id, profile_tab: "#{tab.to_s}")
	end

end