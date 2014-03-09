class Vehicle < ActiveRecord::Base
  belongs_to :user
  belongs_to :vehicle_model

  has_attached_file :image, 
    styles: lambda { |a| {:small => "x100>", :normal => "x300>"} if a.instance.is_image? 
		}

	validates_attachment :image, :size => { in: 0..4.megabytes }
  validates :vehicle_model_id, presence: true

  # virtual attribute getter
  def brand
    @brand = self.try(:vehicle_model).try(:vehicle_brand).try(:id) if self
  end

  def is_image?
    image.instance.image_content_type =~ %r(image)
  end

end
