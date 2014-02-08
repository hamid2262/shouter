class SubtripsController < ApplicationController
	skip_authorization_check	

  def show
    @subtrip = Subtrip.find(params[:id])
  	@hash = Gmaps4rails.build_markers(@subtrip.trip.path_list) do |subtrip, marker|
		  marker.lat subtrip.origin.latitude
		  marker.lng subtrip.origin.longitude
		  marker.infowindow render_to_string(:partial => "subtrips/show/data_for_gmaps", :locals => { subtrip: subtrip})
		end
  end
end
