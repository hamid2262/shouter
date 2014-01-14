class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, 
    styles: lambda { |a| {:thumb => "48x48#", :square => "160x160#"} if a.instance.is_image? },
    default_url: lambda { |a| "#{IMAGES_PATH}#{a.instance.gender}_default_avatar.png"}
  has_attached_file :cover, 
    styles: lambda { |a| {:small => "370x140#", :large => "851x315#"} if a.instance.is_cover? },
    default_url:  "#{IMAGES_PATH}default_cover.png"
  after_create :send_admin_mail

  has_one    :vehicle
  has_many   :trips
  has_many   :bookings  
  belongs_to :city

  has_many :shouts
  has_many :followed_user_relationships, 
  					foreign_key: 'follower_id',
  					class_name: 'FollowingRelationship'
  has_many :followed_users, through: :followed_user_relationships

  has_many :follower_relationships,
  					foreign_key: 'followed_user_id',
  					class_name: 'FollowingRelationship'
  has_many :followers, through: :follower_relationships

  validates :firstname, length:   {maximum: 50}
  validates :lastname,  length:   {maximum: 50}
  validates :email,     uniqueness: true
  validates :username,  uniqueness: true, allow_blank: true
  validates :gender,    presence: true, inclusion: { in: ['f','m'], message: "Please select gender" }
  validates :age,       inclusion:{ in: 0..99 }, allow_blank: true
  # validates :city_id,   presence: true
  validates :tel,       length:{ in: 7..32 }, allow_blank: true
  validates :mobile,    length:{ in: 7..32 }, allow_blank: true
  validates :post_code, length:{ in: 5..15 }, allow_blank: true

  validates_attachment :avatar, :size => { in: 0..1.megabytes }
  validates_attachment :cover,  :size => { in: 0..2.megabytes }

  def gender_in_word
    (self.gender == 'm') ? "Male" :  "Female"
  end

  def is_image?
    avatar.instance.avatar_content_type =~ %r(image)
  end

  def is_cover?
    cover.instance.cover_content_type =~ %r(image)
  end

  def send_admin_mail
    UserMailer.signup_confirmation(self).deliver
  end

  def name
    if self.firstname.present? || self.lastname.present?
      self.try(:firstname).try(:titleize) + " "+ self.try(:lastname).try(:titleize)
    elsif self.username.present?
       self.username
    else      
      self.email.partition("@").first 
   end
  end
  
  def online?
    updated_at > 10.minutes.ago
  end

  def is_admin?
    true if self.admin? || self.email == 'hamid2262@yahoo.com'  
  end

  def following? user
    self.followed_users.include? user
  end

  def can_follow? user
    self != user
  end

  def follow user
    self.followed_users << user
  end

  def unfollow user
    self.followed_users.delete(user)     
  end

  def last_login_city
    Geocoder.search(self.last_sign_in_ip)[0].try(:city)
  end

  def last_login_country
    Geocoder.search(self.last_sign_in_ip)[0].try(:country)
  end

end