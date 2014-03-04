class SpacialEvent < ActiveRecord::Base
  has_attached_file :image, 
    styles: lambda { |a| {:small => "370x140#", :large => "600x200#"} if a.instance.is_image? },
    default_url:  "#{IMAGES_PATH}default_image.jpg"
  before_save :split_address_to_city_state_country
  
   def to_params
   		permalink
   end

 	def is_image?
    image.instance.image_content_type =~ %r(image)
  end

  def search_subtrips_init
    search_subtrip = SearchSubtrip.new
    search_subtrip.origin_address = self.origin_address
    search_subtrip.origin_cycle = self.origin_cycle

    search_subtrip.destination_address = self.destination_address
    search_subtrip.destination_cycle = self.destination_cycle  

    search_subtrip.date = self.end_date  	
    search_subtrip
  end

  def destination
    city = self.destination_country unless self.destination_country.blank?
    city = self.destination_state unless self.destination_state.blank?
    city = self.destination_city unless self.destination_city.blank?    
    city
  end

  private
    def split_address_to_city_state_country
      if self.origin_address   
        address = self.origin_address.split(',')
        self.origin_country = address[-1]
        self.origin_state = address[-2]
        self.origin_city = address[-3]      
      end

      if self.destination_address
        address = self.destination_address.split(',')
        self.destination_country = address[-1]
        self.destination_state = address[-2]
        self.destination_city = address[-3]            
      end
    end

end
