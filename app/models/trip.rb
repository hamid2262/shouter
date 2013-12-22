class Trip < ActiveRecord::Base
  belongs_to :driver, class_name: "User", foreign_key: "user_id"
  has_many   :subtrips , dependent: :destroy
  accepts_nested_attributes_for :subtrips, allow_destroy: true

  def first_city
    path_list.first
  end

  def last_city
    path_list.last  
  end

  def via_cities_obj
    path_list[1..-1]
  end

  def inbetween_cities c1, c2
    i = cities_list.index(c1)
    j = cities_list.index(c2)
    cities_list[i..j]
  end

  def before_cities city
    i = cities_list.index(city)
    cities_list[0..i-1]
  end

  def after_cities city
    i = cities_list.index(city)
    cities_list[i+1..-1]
  end

  def before_and_itself_cities city
    i = cities_list.index(city)
    cities_list[0..i]
  end

  def after_and_itself_cities city
    i = cities_list.index(city)
    cities_list[i..-1]
  end

  def cities_list
    list = []
    path_list.each do |s|
      list << s.origin_id
    end
    list << path_list.last.destination_id
  end

  def path_list
    list = []
    path_list_obj = []
    self.subtrips.each do |c|
      unless list.include?(c.origin.name)
        path_list_obj << c
        list << c.origin.name
      end
    end
    path_list_obj
  end

  def subtrips_init main_subtrip_params
    self.subtrips.build(main_subtrip_params)
    self.save
    return 
    self.fill_subtrips_destination
    self.seats_init
  end

  def seats_init
    self.subtrips.each do |s|
      for i in 1..(self.total_available_seats) do
        s.seats << 0
      end
      s.seats_will_change!
      s.save      
    end

  end

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
