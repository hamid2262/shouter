class NotificationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  # add_template_helper(MailersHelper)
  default from: "hamsafaryab@gmail.com"
  before_action :common_vars
  before_action :set_environment

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.comment_notification_to_shout_owner.subject
  #
  def comment_notification_to_shout_owner(owner, commenter, comment)
    @owner = owner 
    @commenter = commenter
    @comment = comment
    mail to: @owner.email, subject: t(".subject", commenter: @commenter.name)
  end

  def comment_notification_to_shout_commenters(owner, commenters)
    @owner = owner     
    @commenters =commenters

    emails = @commenters.map{|u| u.email}
    mail to: emails, subject: t(".comment_notification")
    
  end

  def common_vars
    attachments.inline['logo.gif'] = File.read("app/assets/images/logo-#{lang_direction}.gif")
    attachments.inline['footer.gif'] = File.read("app/assets/images/headerBG-#{lang_direction}.gif")
    @lang_direction = lang_direction
    @lang_other_side = lang_other_side
    @lang_side = lang_side
  end

  def set_environment
    if Rails.env.production?
      @host = 'hamsafaryab.com'
    else
      @host = 'localhost:3000'
    end
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
