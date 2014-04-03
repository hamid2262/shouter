class AdminMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  default from: "hamsafaryab@gmail.com"

  before_action :common_vars
  # before_action :set_environment

  def contact_us(contact)
    @sender_name = contact[:name]
    @subject =  contact[:subject]
    @message =  contact[:message]
    @email =  contact[:email]
    mail to: "hamsafaryab@gmail.com", subject: "contact up"
  end

private
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
