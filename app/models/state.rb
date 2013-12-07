class State < ActiveRecord::Base

	default_scope order(:local_name)
	has_many   :cities
  belongs_to :country
end
