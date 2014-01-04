class HomesController < ApplicationController

	skip_authorization_check :only => [:show, :create]

  def show
		@search_subtrip = SearchSubtrip.new
  end

  private
    def check_logged_in_user
      if user_signed_in?
      	redirect_to dashboard_path
      end
    end

end
