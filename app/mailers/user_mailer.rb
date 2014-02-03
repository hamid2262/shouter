class UserMailer < ActionMailer::Base
  default from: "hamsafaryab@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup_confirmation.subject
  #
  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "Signup Confirmation"
  end

  def booking_request_to_driver(booking)
    @booking = booking
    @passenger = @booking.passenger
    @driver = @booking.subtrip.trip.driver
    @subtrip = @booking.subtrip

    @jalali_day = jalali_day @subtrip.date_time
    @jalali_day_num =  jalali_day_num @subtrip.date_time
    @jalali_month = jalali_month @subtrip.date_time
    @jalali_time = jalali_time @subtrip.date_time

    @accept = acceptance 'yes'
    @reject = acceptance 'no'
    mail to: @driver.email, subject: "Booking Confirmation"
  end



private

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
end
 