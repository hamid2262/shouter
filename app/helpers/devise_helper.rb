# /app/helpers/devise_helper.rb
 
module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?
 
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
      count: resource.errors.count,
      resource: resource.class.model_name.human.downcase)
 
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">x</button>
      <div class="panel panel-danger">
        <div class="panel-heading">
          <h3 class="panel-title">#{sentence}</h3>
        </div>
      </div>     
      <p>    #{messages} </p>
    </div>
    HTML
 
    html.html_safe
  end
end