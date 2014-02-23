class TripsController < ApplicationController
  
  load_and_authorize_resource 
  skip_load_resource only: [:create] 

  before_action :set_user, only: [:show, :edit]
  before_action :set_trip, only: [:show, :edit, :update, :destroy]
  before_action :set_max_vehicle_seats, only: [:new, :show]
  before_filter :authenticate_user!
  def index
    @trips = current_user.trips.order(updated_at: :desc)     
  end

  def show
    if params[:locale] == "fa"
      @date = @trip.jdate     
    else
      @date = @trip.subtrips.first.date_time.to_s(:date)
    end

    @via_cities = @trip.via_cities
  end

  def new
    @trip = Trip.new
    @trip.subtrips.build
    @trip.subtrips.build
    @trip.subtrips.build
    @trip.subtrips.build
    @trip.subtrips.build
  end

  def edit
  end

  def create
    # array  = filter_empty_subtrips(trip_params)
    @trip = Trip.new(filter_empty_subtrips(trip_params))
    @trip.driver = current_user
    if @trip.save
      @trip.shouts.create!(user_id: current_user.id)
      redirect_to edit_trip_path(@trip.id), notice: t(:trip_create_message) 
    else
      @max_vehicle_seats = 50
      # render action: 'new' 
      redirect_to new_trip_path, alert: t("error_registration") 
    end
  end

  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: t(:trip_update_message) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @trip.destroy
    @shout = Shout.where(content_type: 'Trip', content_id: @trip.id).delete_all
    respond_to do |format|
      format.html { redirect_to trips_path, notice: t(:trip_delete_message) }
      format.json { head :no_content }
    end
  end

  private
    def set_trip
      @trip = Trip.find(params[:id])
    end

    def set_user
      @user = @trip.driver
    end

    def set_max_vehicle_seats
      @max_vehicle_seats = 50
    end
    # def main_subtrip_params
    #   params.require(:first_sub).permit( :origin_id, :destination_id, :seats, 
    #                           :jminute, :jhour, :jyear, :jmonth, :jday)
    # end

    def trip_params
      params.require(:trip).permit(:total_available_seats, :detail,
        subtrips_attributes: [:id, :price, :seats, :_destroy,
                              :olat, :olng, :origin_address,
                              :jminute, :jhour, :jyear, :jmonth, :jday])
    end

    def filter_empty_subtrips(array)
      array["subtrips_attributes"].each_with_index do |tp, index|
        if tp[1]["origin_address"].blank?
          array["subtrips_attributes"].delete "#{index}" 
        end
      end
      array
    end
end
