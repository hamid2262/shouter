module UsersHelper

	def follow_button user, klass = "btn btn-default"
		if current_user.following? user
			button_to 'Unfollow', user_follow_path(user), method: :delete, class: "#{klass}"
		else
			button_to 'Follow', user_follow_path(user), class: "#{klass}"			
		end
	end

end

