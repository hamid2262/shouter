class Page < ActiveRecord::Base

	validates :permalink, presence: true, uniqueness: { case_sensitive: false }
	
	def to_param
		permalink
	end
end
