class Network 

	def initialize user
		@user = user			
	end

	def me
		@user
	end

	def inviter_nth n
		user = @user
		(1..n).each do |s|
			if user.inviter
				user =  user.inviter 
			else
				user = nil
				break
			end
		end
		user
	end

end