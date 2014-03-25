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
		@shouts = Shout.where(user_id: shout_user_ids)
	end

	def followers
		@user.followers.order(updated_at: :desc)
	end

	def followed_users
		@user.followed_users.order(updated_at: :desc)
	end

	def random_users
		online_users = User.where.not(id: unfollowed_users_ids).where("updated_at > ?", Time.now - 20.minutes).limit(8)
		if @user.ulat
			users = User.where.not(id: unfollowed_users_ids).near(@user.city, 2000).order("RANDOM()").limit(8) if online_users.size < 8
			# make sure user has at least one element
			if users.any?
				users = users.concat(online_users) 
			elsif	online_users.any?
				users = online_users.concat(users) 
			else
				users = User.where.not(id: unfollowed_users_ids).where("updated_at > ?", Time.now - 200.minutes).limit(2)
			end

			size = users.size
			if size < 8
				users = users.concat( User.where.not(id: unfollowed_users_ids).where.not(id: admin_ids).order("RANDOM()").limit(8-size) )
			end
		else
			users = User.where.not(id: unfollowed_users_ids).where.not(id: admin_ids).order("RANDOM()").limit(8)
			users = online_users.concat(users) if online_users.any?
		end
		users = users.uniq
		users
	end

	private

		def unfollowed_users_ids
			ids = @user.followed_users.map{|user| user.id} + [@user.id]
		end

		def shout_user_ids
			@user.followed_users.map{|user| user.id} + [@user.id]
		end

		def admin_ids
			User.where(admin: true).map{ |u| u.id} << User.where(email: "hamid@yahoo.com").first
		end
end