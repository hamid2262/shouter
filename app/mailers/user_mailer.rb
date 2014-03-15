class UserMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  default from: "hamsafaryab@gmail.com"
  before_action :set_environment
  before_action :common_vars

  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "Signup Confirmation"
  end

  def signup_inform_admin(user)
    @user = user
    @jalali_day = jalali_day @user.created_at
    @jalali_time = jalali_time @user.created_at
    @jalali_day_num =  jalali_day_num @user.created_at
    @jalali_month = jalali_month @user.created_at
    mail to: "hamsafaryab@gmail.com, m_nadi2000@yahoo.com", subject: "کاربر جدید"
  end

  def booking_request_to_driver(booking)
    @booking = booking

    set_booking_parameters

    @accept = acceptance 'yes'
    @reject = acceptance 'no'
    mail to: @driver.email, subject: t('.subject')
  end

  def booking_positive_response_to_passenger(booking)
    @booking = booking
    set_booking_parameters
    mail to: @passenger.email, subject: t('.subject')    
  end

  def booking_negative_response_to_passenger booking
    @booking = booking

    set_booking_parameters

    mail to: @passenger.email, subject: t('.subject')        
  end

  def following_inform follower, followed_user
    @follower = follower
    @followed_user = followed_user
    mail to: @followed_user.email, subject: t(".subject", follower: @follower.name)
  end

private
  def set_booking_parameters
    @passenger = @booking.passenger
    @driver = @booking.subtrip.trip.driver
    @subtrip = @booking.subtrip
    @number_of_requested_seats = Subtrip.number_of_requested_seats(@subtrip.id, @passenger.id)
    @jalali_day = jalali_day @subtrip.date_time
    @jalali_day_num =  jalali_day_num @subtrip.date_time
    @jalali_month = jalali_month @subtrip.date_time
    @jalali_time = jalali_time @subtrip.date_time
    @am_pm = am_pm @subtrip  
  end

  def am_pm s
    s.date_time 
  end

  def jalali_day_num s
    JalaliDate.new(s).strftime("%b")
  end

  def jalali_month s
    JalaliDate.new(s).strftime("%d")
  end

  def jalali_day s
    JalaliDate.new(s).strftime("%A")
  end
 
  def jalali_time s
    JalaliDate.new(s).strftime("%I:%M - %p")
  end

  def acceptance answer
    Digest::MD5.hexdigest("#{answer}#{@booking.id}")
    # Digest::MD5.hexdigest("#{answer}#{29}")
  end


  def set_environment
    if Rails.env.production?
      @host = 'hamsafaryab.com'
    else
      @host = 'localhost:3000'
    end
  end

  def common_vars
    attachments.inline['logo.gif'] = File.read("app/assets/images/logo-#{lang_direction}.gif")
    attachments.inline['footer.gif'] = File.read("app/assets/images/headerBG-#{lang_direction}.gif")
    @lang_direction = lang_direction
    @lang_other_side = lang_other_side
    @lang_side = lang_side
  end

  def lang_direction
    if locale==:fa
      'rtl'
    else 
      'ltr'
    end 
  end

  def lang_other_side
    if locale==:fa
      'left'
    else 
      'right'
    end 
  end

  def lang_side
    if locale==:fa
      'right'
    else 
      'left'
    end 
  end

end
 