module ProfilesHelper

	def link_to_profile user
		name = truncate(profile_url(@profile.user), length: 40, omission: '').gsub("http://", "")		
		link_to name, profile_url(@profile.user),class: "small"
	end
end
