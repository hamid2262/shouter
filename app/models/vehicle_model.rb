class VehicleModel < ActiveRecord::Base
  has_many   :vehicles 
  belongs_to :vehicle_brand
end
