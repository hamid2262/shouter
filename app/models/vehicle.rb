class Vehicle < ActiveRecord::Base
  belongs_to :user
  belongs_to :vehicle_model

  validates :number_plate, presence: true
  
end
