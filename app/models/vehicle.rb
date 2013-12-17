class Vehicle < ActiveRecord::Base
  belongs_to :user
  belongs_to :vehicle_model

  validates :number_plate, presence: true
  
  has_attached_file :image, styles: {
	  thumb: '100x100>',
	  square: '200x200#',
	  medium: '300x300>'
  }
end
