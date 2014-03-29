class Branch < ActiveRecord::Base

  geocoded_by :city, latitude: :blat, longitude: :blng
  after_validation :geocode, :if => :city_changed?

  belongs_to :company
  belongs_to :manager, class_name: 'User', foreign_key: "user_id"

  has_many :branch_driver_relationships            
  has_many :drivers, through: :branch_driver_relationships 

  validates :slug, presence: true, uniqueness: { case_sensitive: true }
  validates :name, presence: true
  validates :company, presence: true
  validates :manager, presence: true
  
  has_attached_file :cover, 
    styles: lambda { |a| {:small => "370x140#", :large => "851x315#"} if a.instance.is_cover? },
    default_url:  "#{IMAGES_PATH}default_cover.jpg"

  def is_cover?
    cover.instance.cover_content_type =~ %r(image)
  end
  
  def to_param
    self.slug
  end

  def mycover  
    if self.cover.present?
      self.cover
    else
      self.company.cover
    end
  end

  def active_drivers
    self.drivers.merge(BranchDriverRelationship.where(active: true) )
  end

  def timeline
    @shouts = Shout.where(user_id: shout_user_ids)
  end

  def name_with_company
    "#{self.company.name}. #{name}"
  end


  private

    def shout_user_ids
      self.drivers.map{|user| user.id} + [self.manager.id]
    end
end
