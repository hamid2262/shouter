require 'digest/sha1'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  has_attached_file :avatar, 
    styles: lambda { |a| {:thumb => "48x48#", :square => "160x160#"} if a.instance.is_image? },
    default_url: lambda { |a| "#{IMAGES_PATH}#{a.instance.gender}_default_avatar.png"}
  has_attached_file :cover, 
    styles: lambda { |a| {:small => "370x140#", :large => "851x315#"} if a.instance.is_cover? },
    default_url:  "#{IMAGES_PATH}default_cover.jpg"
  after_create :send_admin_mail

  # SLUG_REGEX =         
  validates :slug, uniqueness: { case_sensitive: false }, 
                    length: { in: 8..39},
                    format: { with: /\A[a-zA-Z][a-zA-Z0-9_-]+\z/i, message: "must be include letter and number and - , _ "  }, on: :update,
                    if: :has_slug_changed?
  validate :check_for_slud_updated_one_time
  before_create :generate_slug
  before_update :update_slug_update

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


# invitation
  has_many :invited_user_relationships, 
            foreign_key: 'inviter_id',
            class_name: 'Invitation'
  has_many :invited_users, through: :invited_user_relationships

  has_one :inviter_relationship,
            foreign_key: 'invited_user_id',
            class_name: 'Invitation'
  has_one :inviter, through: :inviter_relationship


  validates :firstname, length:   {maximum: 50}
  validates :lastname,  length:   {maximum: 50}
  validates :email,     uniqueness: true
  validates :username,  uniqueness: true, allow_blank: true
  validates :gender,    presence: true, inclusion: { in: ['f','m'], message: "Please select gender" }
  validates :age,       inclusion:{ in: 0..99 }, allow_blank: true
  # validates :city_id,   presence: true
  validates :tel,       length:{ in: 7..20  }, allow_blank: true
  validates :mobile,    length:{ in: 7..20  }, allow_blank: true
  validates :address,   length:{ in: 4..250 }, allow_blank: true
  validates :post_code, length:{ in: 5..15  }, allow_blank: true

  validates_attachment :avatar, :size => { in: 0..4.megabytes }
  validates_attachment :cover,  :size => { in: 0..4.megabytes }

  def self.find_for_facebook_oauth(auth)
    user = User.where(email: auth.info.email).first
    if user.nil?
        user = User.new
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.firstname = auth.info.first_name   
        user.lastname = auth.info.last_name   
        user.gender = auth.extra.raw_info.gender[0]
        user.location = auth.extra.raw_info.location.try(:name)
        user.facebook_image_url = auth.info.image
        user.save!
    else 
      if user.uid.nil?
        user.provider = auth.provider
        user.uid = auth.uid
        user.facebook_image_url = auth.info.image          
        user.firstname = auth.info.first_name  if user.firstname.nil?
        user.lastname = auth.info.last_name  if user.lastname.nil?
        user.location = auth.extra.raw_info.location.try(:name) if auth.extra.raw_info.location.try(:name).present?
      else      
        user.facebook_image_url = auth.info.image          
        user.location = auth.extra.raw_info.location.try(:name) if auth.extra.raw_info.location.try(:name).present?
      end
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def update_slug_update
    self.slug_updated = true  if self.slug_changed?
  end

  def generate_slug
    self.slug = Digest::SHA1.hexdigest(self.email)
  end

  def has_slug_changed?
    false
    true if self.slug_changed?
  end

  def check_for_slud_updated_one_time
    errors.add(:base, 'Url can be changed only one time') if(self.slug_updated && self.slug_changed?)
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

  def last_login_location
    return 'no data' if (self.email == "hamid2262@yahoo.com") or (self.last_sign_in_ip == '93.131.104.148')
    country = self.last_login_country if self.last_login_country.present?
    unless self.try(:last_login_city).blank?
      city =  ', '+ self.try(:last_login_city).to_s 
    end
    if  country && city
      city + ', ' + country
    elsif city
      city
    elsif country
      country
    else
      'no data'
    end
  end

end