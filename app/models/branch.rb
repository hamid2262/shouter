class Branch < ActiveRecord::Base

  geocoded_by :city, latitude: :blat, longitude: :blng
  after_validation :geocode, :if => :city_changed?

  belongs_to :company
  belongs_to :manager, class_name: 'User', foreign_key: "user_id"

  has_many :branch_driver_relationships            
  has_many :drivers, through: :branch_driver_relationships 

  validates :name, presence: true
  validates :slug, presence: true
  validates :company, presence: true
  validates :manager, presence: true
  
  has_attached_file :cover, 
    styles: lambda { |a| {:small => "370x140#", :large => "851x315#"} if a.instance.is_cover? },
    default_url:  "#{IMAGES_PATH}default_cover.jpg"

  def is_cover?
    cover.instance.cover_content_type =~ %r(image)
  end

end
