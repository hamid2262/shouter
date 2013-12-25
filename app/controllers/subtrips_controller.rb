class SubtripsController < ApplicationController
  before_action :set_subtrip, only: [:show]
  
	skip_authorization_check	

  def show
  end

  
  private
    def set_subtrip
	    @subtrip = Subtrip.find(params[:id])
    end
  
end
