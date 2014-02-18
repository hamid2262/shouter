class SpacialEvent < ActiveRecord::Base
  belongs_to :origin, class_name: "City", foreign_key: "origin_id"
  belongs_to :destination, class_name: "City", foreign_key: "destination_id"
	
  has_attached_file :image, 
    styles: lambda { |a| {:small => "370x140#", :large => "600x200#"} if a.instance.is_image? },
    default_url:  "#{IMAGES_PATH}default_image.jpg"
  
   def to_params
   		permalink
   end

 	def is_image?
    image.instance.image_content_type =~ %r(image)
  end

  def search_subtrips_init
    search_subtrip = SearchSubtrip.new
    search_subtrip.origin_id = self.origin_id
    search_subtrip.origin_cycle = self.origin_cycle
    search_subtrip.destination_id = self.destination_id
    search_subtrip.destination_cycle = self.destination_cycle  	
    search_subtrip
  end
end
