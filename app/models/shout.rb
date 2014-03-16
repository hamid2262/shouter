class Shout < ActiveRecord::Base

  belongs_to :user
  belongs_to :content, polymorphic: true

  default_scope { order( "created_at DESC" ) }

  # def self.text_shouts
  # 	where(content_type: 'TextShout')	
  # end
  
  def self.photo_shouts
  	where(content_type: 'PhotoShout')	
  end

  def self.trip_shouts
  	where(content_type: 'Trip')	
  end

end
