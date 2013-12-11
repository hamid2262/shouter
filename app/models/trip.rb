class Trip < ActiveRecord::Base
  belongs_to :driver, class_name: "User", foreign_key: "user_id"
  has_many   :subtrips , dependent: :destroy
  accepts_nested_attributes_for :subtrips, allow_destroy: true


  def fill_subtrips_destination 
    cities_ids = create_city_array self       
    for i in 0..(cities_ids.size-1)
      origin = self.subtrips.where(origin_id: cities_ids[i]).first   
      for j in (i+1)..(cities_ids.size-1)
        unless main_subtrip(cities_ids, i, j) then
          subtrips = self.subtrips.where(origin_id: cities_ids[i], destination_id: nil)            
          if subtrips.any?
            subtrips.first.update(destination_id: cities_ids[j])
            subtrips.first.save
          else
            self.subtrips.build(origin_id: origin.origin_id, price: origin.price, datetime: origin.datetime, destination_id: cities_ids[j])
            self.save
          end
        end
      end
    end
  end

  private
	  def main_subtrip cities_ids, i, j
	    true if cities_ids[i]== cities_ids[0] && cities_ids[j]==cities_ids[cities_ids.size-1]
	  end
	  def create_city_array trip
	    cities_ids = []
	    main_trip = trip.subtrips.where.not(destination_id: nil).first
	    cities_ids << main_trip.origin_id
	    trip.subtrips.where(destination_id: nil).each do  |sub|
	      cities_ids <<  sub.origin_id
	    end
	    cities_ids << main_trip.destination_id      
	    cities_ids
	  end
	  
end
