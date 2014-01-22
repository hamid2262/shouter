class TripsController < ApplicationController
  
  load_and_authorize_resource 
  skip_load_resource only: [:create] 

  before_action :set_trip, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  def index
    # @trips = Trip.all
  end

  def show
  end

  def new
    @max_vehicle_seats = 8
    @trip = Trip.new
    @trip.subtrips.build
    @trip.subtrips.build
  end

  def edit
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.driver = current_user

    respond_to do |format|
      if @trip.save
        # @data = @trip.subtrips_init 
        # return false
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

    # def main_subtrip_params
    #   params.require(:first_sub).permit( :origin_id, :destination_id, :seats, 
    #                           :jminute, :jhour, :jyear, :jmonth, :jday)
    # end

    def trip_params
      params.require(:trip).permit(:total_available_seats, :detail,
        subtrips_attributes: [:id, :origin_id, :price, :seats, :_destroy, 
                              :jminute, :jhour, :jyear, :jmonth, :jday])    
    end

    # def vehicle_seats_number user
    #   if user && user.vehicle.present?
    #     user.vehicle.vehicle_model.seats_number
    #   else
    #     flash[:notice] = t(:enter_vehicle_detail_message)
    #     session[:return_to] = new_trip_path
    #     redirect_to new_user_vehicles_path(user)
    #   end
    # end

end
