class VehicleBrand < ActiveRecord::Base
	has_many :vehicle_models
end
