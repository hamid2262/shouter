class City < ActiveRecord::Base
  belongs_to :state
  has_many   :users

  has_many	:outgoing_trips, class_name: "Subtrip", foreign_key: "origin_id"
  has_many  :incoming_trips, class_name: "Subtrip", foreign_key: "destination_id"
  default_scope { order(:id, :local_name) }
  scope :sorted, -> { order(:name) }

  geocoded_by :name
	after_validation :geocode, :if => :name_changed?

	validates_numericality_of :latitude, message: "Review the address, if it is correct, please submit"
	validates_numericality_of :longitude, message: "Review the address, if it is correct, please submit"
	validates :state_id, presence: true

	def extract_lat 
		geomap.geometry["location"]["lat"]
	end

	def extract_lng 
		geomap.geometry["location"]["lng"]
	end

	def extract_name 
		geomap.address_components.first["long_name"] || geomap.address_components.first["short_name"]
	end

	def geomap
	  Geocoder.search( self.local_name ).first
	end

end
