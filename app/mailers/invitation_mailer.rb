class InvitationMailer < ActionMailer::Base
  before_action :set_environment
  before_action :common_vars

  def invite(inviter, invited_email)
    @inviter = inviter
    @inviter_profile_url = url_finder @inviter
    mail(from: @inviter.email, to: invited_email, subject: t('.subject'), locale: locale )
  end

  def inform_inviter(invited_user, inviter)
    @inviter = inviter
    @invited_user = invited_user
    @inviter_profile_url = url_finder @inviter
    @invited_user_profile_url = url_finder @invited_user
    mail(from: 'hamsafaryab@gmail.com', to: inviter.email, subject: t('.subject') , locale: locale )
  end

private
  def set_environment
    if Rails.env.production?
      @host = 'hamsafaryab.com'
    else
      @host = 'localhost:3000'
    end
  end

  def url_finder user
    root_url(locale: locale)[0..-4]+"/"+ user.slug
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
