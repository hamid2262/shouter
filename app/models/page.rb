class Page < ActiveRecord::Base
	translates :name, :content
	validates :permalink, presence: true, uniqueness: { case_sensitive: false }
	
	def to_param
		permalink
	end
end
