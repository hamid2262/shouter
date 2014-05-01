class HomesController < ApplicationController
	skip_authorization_check :only => [:show, :lang_select]
  before_action  :redirect_to_appropriate_lang
  def show
    if current_user
      redirect_to dashboard_path 
      return false
    end
    # unless (request.try(:location).try(:country_code) == 'IR')  
    #   if (request.original_url.include? "/en")
    #     new_url = request.original_url.gsub! '/en', '/fa'
    #     cookies[:lang] = :fa
    #     I18n.locale =  :fa
    #     redirect_to new_url
    #     return false
    #   end
    # end

		@search_subtrip = SearchSubtrip.new

		@subtrips = Home.newtrips.limit(8)

		@spacial_events = Home.spacial_events.limit(7)
  end

  def lang_select
    old_url = URI.unescape params[:url]
    new_url = root_url
    lang = params[:lang]
  	if lang == "en"
  		cookies[:lang] = :en
  		new_url = old_url.sub '/fa', '/en'
  	elsif lang == "fa"
      cookies[:lang] = :fa
  		new_url = old_url.sub '/en', '/fa'
  	end
    redirect_to new_url
  end

  private

    def redirect_to_appropriate_lang
      if cookies[:lang].nil?
        if request.original_url.include?("/fa")
          cookies[:lang] = :fa   
          redirect_to root_url    
        end        
      end
    end
end