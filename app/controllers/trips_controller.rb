class TripsController < ApplicationController
  
  layout 'application_new_jquery'

  skip_authorization_check

  before_action :set_trip, only: [:show, :edit, :update, :destroy]

  def index
    @trips = Trip.all
  end

  def show
  end

  def new
    @vehicle_seats = vehicle_seats_number current_user
    @trip = Trip.new
    @sub = Subtrip.new
  end

  def edit
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

  def create
    @trip = Trip.new(trip_params)
    @trip.driver = current_user
    respond_to do |format|
      if @trip.save
        @trip.subtrips_init main_subtrip_params
    @data = params
    return false        
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render action: 'show', status: :created, location: @trip }
      else
        format.html { render action: 'new' }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_trip
      @trip = Trip.find(params[:id])
    end

    def main_subtrip_params
      params.require(:first_sub).permit(:origin_id, :destination_id, :seats, :jalali_year,:datetime, :jalali_month, :jalali_day, :jalali_hour, :jalali_minute)
    end

    def trip_params
      params.require(:trip).permit(:total_available_seats, :detail,
                                  subtrips_attributes: [:id, :origin_id, :price, :seats, :_destroy,:datetime, :jalali_year, :jalali_month, :jalali_day, :jalali_hour, :jalali_minute])    
    end

    def vehicle_seats_number user
      if user && user.vehicle.present?
        user.vehicle.vehicle_model.seats_number
      else
        flash[:notice] = "First enter detail of your vehicle"
        session[:return_to] = new_trip_path
        redirect_to new_user_vehicles_path(user)
      end
    end

end