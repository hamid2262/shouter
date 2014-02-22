class SubtripsController < ApplicationController
	skip_authorization_check	
	after_action :increment_view

  def show
    @subtrip = Subtrip.find(params[:id])
  	@hash = Gmaps4rails.build_markers(@subtrip.trip.path_list) do |subtrip, marker|
		  marker.lat subtrip.olat
		  marker.lng subtrip.olng
		  marker.infowindow render_to_string(:partial => "subtrips/show/data_for_gmaps", :locals => { subtrip: subtrip})
		end
  end

  private

  def increment_view
  	unless current_user && current_user.is_admin?
    	@subtrip.update_attributes(view: (@subtrip.view + 1))
    end
  end
end
