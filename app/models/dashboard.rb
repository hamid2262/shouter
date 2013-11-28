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

	private
	
	def shout_user_ids
		@user.followed_users.map{|user| user.id} + [@user.id]		
	end
end