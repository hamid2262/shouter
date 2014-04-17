class VehicleBrand < ActiveRecord::Base
	translates :name

	has_many :vehicle_models
end
