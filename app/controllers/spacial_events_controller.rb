class SpacialEventsController < ApplicationController
  before_action :set_spacial_event, only: [:show, :edit, :update, :destroy]
  authorize_resource 
  layout 'application_user'#, only: [:special_events]

  # GET /spacial_events
  # GET /spacial_events.json
  def index
    @spacial_events = SpacialEvent.all
  end

  # GET /spacial_events/1
  # GET /spacial_events/1.json
  def show
    @search_subtrip = @spacial_event.search_subtrips_init
    @subtrips = @search_subtrip.subtrips(17).page(params[:page]).per_page(10) if @search_subtrip
  end

  # GET /spacial_events/new
  def new
    @spacial_event = SpacialEvent.new
  end

  # GET /spacial_events/1/edit
  def edit
  end

  # POST /spacial_events
  # POST /spacial_events.json
  def create
    @spacial_event = SpacialEvent.new(spacial_event_params)

    respond_to do |format|
      if @spacial_event.save
        format.html { redirect_to spacial_event_path(@spacial_event.permalink), notice: 'Spacial event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @spacial_event }
      else
        format.html { render action: 'new' }
        format.json { render json: @spacial_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spacial_events/1
  # PATCH/PUT /spacial_events/1.json
  def update
    respond_to do |format|
      if @spacial_event.update(spacial_event_params)
        format.html { redirect_to spacial_event_path(@spacial_event.permalink), notice: 'Spacial event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @spacial_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spacial_events/1
  # DELETE /spacial_events/1.json
  def destroy
    @spacial_event.destroy
    respond_to do |format|
      format.html { redirect_to spacial_events_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spacial_event
      @spacial_event = SpacialEvent.find_by!(permalink: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spacial_event_params
      params.require(:spacial_event).permit(:title, :image, :permalink, :start_date, :end_date,
                                            :olat, :olng, :origin_address, :origin_cycle, 
                                            :dlat, :dlng, :destination_address, :destination_cycle 
                                            )
    end
end
