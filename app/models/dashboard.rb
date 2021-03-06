class Dashboard 

	def initialize user
		@user = user			
	end

	def new_text_shout
		TextShout.new	
	end

	def new_photo_shout
		PhotoShout.new
	end
	
	def timeline
		Shout.where(user_id: shout_user_ids).includes(:user).includes(:content)
	end

	def followers
		@user.followers.order(updated_at: :desc).uniq
	end

	def followed_users
		@user.followed_users.order(updated_at: :desc).uniq
	end

	def random_users
		online_users = User.where.not(id: unfollowed_users_ids).where.not(id: super_admin_ids).where("updated_at > ?", DateTime.now - 10.minutes).where(active: true).limit(8)
		size = online_users.size
		if @user.ulat
			users = User.where.not(id: unfollowed_users_ids).near(@user.city, 2000).order("RANDOM()").where(active: true).limit(8-size)
			size = users.size + size
			if size < 8
				rand_user = User.where.not(id: unfollowed_users_ids).where.not(id: super_admin_ids).order("RANDOM()").where("users.avatar_file_name IS NOT NULL").limit(8-size) 
				users = rand_user.concat(users)
				users = users.uniq
			end
		else
			users = User.where.not(id: unfollowed_users_ids).where.not(id: super_admin_ids).where(active: true).where("users.avatar_file_name IS NOT NULL").order("RANDOM()").limit(8-size)
		end
		users = online_users.concat(users) if online_users.any?
		users
	end

	def shout_user_ids
		@user.followed_users.map{|user| user.id} + [@user.id]
	end

	private

		def unfollowed_users_ids
			@user.followed_users.map{|user| user.id} + [@user.id]
		end

		def super_admin_ids
			User.where(id: [1, 11])
		end
end