class TripsController < ApplicationController
  
  load_and_authorize_resource 
  skip_load_resource only: [:create] 

  before_action :set_user, only: [:show, :edit]
  before_action :set_trip, only: [:show, :edit, :update, :destroy]
  before_action :set_max_vehicle_seats, only: [:new, :show]
  before_action :authenticate_user!
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
    @commentable = @trip
    @comments = @commentable.comments
    @comment = Comment.new
  end

  def start_new_trip
    check_for_mobile
    if current_user.is_admin?  || current_user.owned_branch
      redirect_to action: 'select_driver'
    elsif locale == :fa 
      redirect_to action: 'select_date_format'
    else
      redirect_to action: 'new'
    end
    return false
  end

  def select_driver
    if current_user.is_admin?
      @drivers = User.joins(:branch_driver_relationships)
    else
      @drivers = current_user.owned_branch.drivers
    end
  end

  def accept_driver
    session[:driver_id] = params[:trip][:driver_id]
    if locale == :fa 
      redirect_to action: 'select_date_format'     
    else
      redirect_to action: 'new'   
    end
  end

  def select_date_format
  end

  def accept_date_format
    session[:date_format] = params[:date_format]
    redirect_to action: 'new'
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
     if params[:locale] == "fa"
      @date = @trip.jdate     
    else
      @date = @trip.subtrips.first.date_time.to_s(:date)
    end
  end

  def create
    # array  = filter_empty_subtrips(trip_params)
    @trip = Trip.new(filter_empty_subtrips(trip_params))
    if session[:driver_id]
      driver = User.find session[:driver_id]
      session[:driver_id] = nil
    else
      driver = current_user
    end
    @trip.driver = driver
    @trip.subtrips.each do |s|
      s.currency_id = @trip.currency_id
    end
    if @trip.save
      @trip.shouts.create!(user_id: driver.id)
      redirect_to edit_trip_path(@trip.id) #, notice: t(:trip_create_message) 
    else
      redirect_to new_trip_path, alert: t("error_registration") 
    end
    
  end

  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip }#, notice: t(:trip_update_message) 
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
      if current_user.owned_branch
        format.html { redirect_to company_branch_path(company_id: current_user.owned_branch.company, branch_id: current_user.owned_branch), notice: t(:trip_delete_message) }
      else
        format.html { redirect_to trips_path, notice: t(:trip_delete_message) }
      end
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

    def trip_params
      params.require(:trip).permit(:total_available_seats, :detail, :currency_id, :ladies_only,
        subtrips_attributes: [:id, :price, :seats, :_destroy,
                              :olat, :olng, :origin_address,
                              :date_time, :jminute, :jhour, :jyear, :jmonth, :jday])
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
