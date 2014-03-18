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
		User.where.not(id: unfollowed_users_ids).where.not(id: admin_ids).order(updated_at: :desc).limit(8)
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