class State < ActiveRecord::Base

	has_many   :cities
  belongs_to :country

	validates :country_id, presence: true
	
	default_scope { order(:local_name) }
	
end
