class Profile 

	def initialize user
		@user = user			
	end

  def to_param
    @user.slug
  end

  def user
  	@user
  end

  def bookings_count
  	@user.bookings.size
  end

  def trips_count
  	@user.trips.size
  end

  def booking_canceled_count
  	# @user.bookings.where(cancel: true).size
  	0
  end

  def trip_canceled_count
  	# @user.trips.where(cancel: true).count
  	0
  end

	def timeline
		@shouts = Shout.where(user_id: shout_user_ids)
	end

	def followed_users
		@user.followed_users.order(updated_at: :desc)
	end
	
	def followers
		@user.followers.order(updated_at: :desc)
	end

	def random_users
		User.where.not(id: unfollowed_users_ids).order(updated_at: :desc)
	end

	private

		 def unfollowed_users_ids
			ids = @user.followed_users.map{|user| user.id} + [@user.id]
		 end

		def shout_user_ids
			# @user.followed_users.map{|user| user.id} + [@user.id]
			[@user.id]
		end
end