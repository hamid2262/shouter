class InvitationMailer < ActionMailer::Base
  before_action :set_environment

  def invite(inviter, invited_email)
    @inviter = inviter
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

end
