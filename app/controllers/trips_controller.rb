class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]

  def index
    @trips = Trip.all
  end

  def show
  end

  def new
    @trip = Trip.new
    @sub = Subtrip.new
  end

  def edit
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.driver = current_user
    respond_to do |format|
      if @trip.save
        @trip.subtrips.build(subtrip_first_params)
        @trip.save
        @trip.fill_subtrips_destination
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render action: 'show', status: :created, location: @trip }
      else
        format.html { render action: 'new' }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url }
      format.json { head :no_content }
    end
  end

  private
    def set_trip
      @trip = Trip.find(params[:id])
    end

    def subtrip_first_params
      params.require(:first_sub).permit(:datetime, :origin_id, :destination_id)
    end

    def trip_params
      params.require(:trip).permit(:total_available_seats, :detail,
                                  subtrips_attributes: [:id, :origin_id, :price, :datetime, :_destroy])    
    end
   
end
