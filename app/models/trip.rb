class Trip < ActiveRecord::Base
  has_many   :subtrips , dependent: :destroy
  has_many   :shouts, as: :content, dependent: :destroy
  has_many   :comments, as: :commentable, dependent: :destroy

  belongs_to :driver, class_name: "User", foreign_key: "user_id"
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  
  belongs_to :currency

  accepts_nested_attributes_for :subtrips, allow_destroy: true

  validates_associated :subtrips
  validates :driver, presence: true

  after_create :subtrips_init

  def jdate
    JalaliDate.new( self.subtrips.first.date_time ).strftime("%d %b %Y") 
  end

  def first_city
    path_list.first
  end
 
  def last_city
    path_list.last  
  end

  def via_cities
    path_list[1..-2]
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
      list << s.origin_address
    end
    list << path_list.last.destination_address
  end

  def path_list
    list = []
    path_list = []
    self.subtrips.each do |c|
      unless list.include?(c.origin)
        path_list << c
        list << c.origin
      end
    end
    path_list
  end

  # initialize other subtrips and fill destination cities 
  def subtrips_init 
    if self.subtrips.any? && self.subtrips.last.destination_country.nil?
      subtrips = self.subtrips.order(:date_time) 
      for i in 0..(subtrips.size-1)
        if subtrips[i+1]
          subtrips[i].destination_address = subtrips[i+1].origin_address
          subtrips[i].dlat = subtrips[i+1].olat
          subtrips[i].dlng = subtrips[i+1].olng
          for j in (i+2)..(subtrips.size-1)
              self.subtrips.build(olat: subtrips[i].olat, 
                                  olng: subtrips[i].olng, 
                                  origin_address: subtrips[i].origin_address, 

                                  price: subtrips[i].price, 
                                  date_time: subtrips[i].date_time, 
                                  jminute: subtrips[i].jminute, 
                                  jhour: subtrips[i].jhour, 
                                  jday: subtrips[i].jday, 
                                  jmonth: subtrips[i].jmonth, 
                                  jyear: subtrips[i].jyear, 

                                  dlat: subtrips[j].olat,
                                  dlng: subtrips[j].olng,
                                  destination_address: subtrips[j].origin_address
                                 )
              self.save
          end
        else
          subtrips[i].dlat = subtrips[i].olat        
          subtrips[i].dlng = subtrips[i].olng
          subtrips[i].destination_address = subtrips[i].origin_address
        end
        subtrips[i].save
      end
      estimate_prices
    end
  end


private

  def estimate_prices
    unit_price = self.currency.unit_price
    price_step = self.currency.price_step
    self.subtrips.each do |subtrip|
      if subtrip.olat && subtrip.dlat && subtrip.price.nil?
        distance = subtrip.distance_to([subtrip.olat,subtrip.olng]) * 2 
        price = (distance.round(0)) * unit_price / 20
        subtrip.price = (price.to_i / price_step) * price_step + price_step   
        subtrip.save!       
      end
    end
  end

end
