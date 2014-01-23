class Trip < ActiveRecord::Base
  belongs_to :driver, class_name: "User", foreign_key: "user_id"
  has_many   :subtrips , dependent: :destroy
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

  def via_cities_obj
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

  # initialize other subtrips and fill destination cities id
  def subtrips_init 
    subtrips = self.subtrips.order(:date_time) 
    for i in 0..(subtrips.size-1)
      if subtrips[i+1]
        subtrips[i].destination_id = subtrips[i+1].origin_id
        for j in (i+2)..(subtrips.size-1)
            self.subtrips.build(origin_id: subtrips[i].origin_id, 
                                price: subtrips[i].price, 
                                date_time: subtrips[i].date_time, 
                                jminute: subtrips[i].jminute, 
                                jhour: subtrips[i].jhour, 
                                jday: subtrips[i].jday, 
                                jmonth: subtrips[i].jmonth, 
                                jyear: subtrips[i].jyear, 
                                destination_id: subtrips[j].origin_id
                               )
            self.save
        end
      else
        subtrips[i].destination_id = subtrips[i].origin_id        
      end
      subtrips[i].save
    end
  end


  private


end
