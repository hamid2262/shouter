class VehicleModel < ActiveRecord::Base
	translates :name

  has_many   :vehicles 
  belongs_to :vehicle_brand
end
