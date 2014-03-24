class Company < ActiveRecord::Base

	has_many :branches

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: false }

  has_attached_file :image, 
    styles: lambda { |a| {:thumb => "160x48#", :medium => "340x100#"} if a.instance.is_image? },
    default_url: lambda { |a| "#{IMAGES_PATH}default_avatar.png"}

  has_attached_file :cover, 
    styles: lambda { |a| {:small => "370x140#", :large => "851x315#"} if a.instance.is_cover? },
    default_url:  "#{IMAGES_PATH}default_cover.jpg"

  def is_image?
    image.instance.image_content_type =~ %r(image)
  end

  def is_cover?
    cover.instance.cover_content_type =~ %r(image)
  end

  def to_param
    self.slug
  end

end
