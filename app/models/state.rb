class State < ActiveRecord::Base

	default_scope order(:local_name)
	has_many   :cities
  belongs_to :country

	validates :country_id, presence: true

end
