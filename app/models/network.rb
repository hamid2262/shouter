class Network 
	def initialize user
		@user = user			
	end

	def current
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

	def self.network_size user
		count = 0
		user.invited_users.each do |child1|
			count += 1
			child1.invited_users.each do |child2|
				count += 1
				child2.invited_users.each do |child3|
					count += 1
					child3.invited_users.each do |child4|
						count += 1
					end
				end
			end
		end
		count
	end

end