class SubtripsController < ApplicationController
  before_action :set_subtrip, only: [:show, :edit, :update]  
	after_action :increment_view
  authorize_resource  

  def show
    @driver = @subtrip.trip.driver
    if @subtrip.trip.driver.branches.any?
      @branch = @subtrip.trip.driver.branches.first 
      @company = @branch.company
    end
  	@hash = Gmaps4rails.build_markers(@subtrip.trip.path_list) do |subtrip, marker|
		  marker.lat subtrip.olat
		  marker.lng subtrip.olng
		  marker.infowindow render_to_string(:partial => "subtrips/show/data_for_gmaps", :locals => { subtrip: subtrip})
		end
  end


  # GET /currencies/1/edit
  def edit
  end

  def update
        
    respond_to do |format|
      if @subtrip.take_all_conflict_seats params[:seat_numbers]
        format.html { redirect_to edit_subtrip_path, notice: t('flash.seats_deleted_successfully') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @subtrip.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_subtrip
      @subtrip = Subtrip.find(params[:id])
    end

    def increment_view
    	unless current_user && current_user.is_admin?
      	@subtrip.update_attributes(view: (@subtrip.view + 1))
      end
    end
end
