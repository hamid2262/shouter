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
    reset_sessions
    if check_for_mobile
    elsif current_user.is_admin?  || current_user.owned_branch
      return redirect_to action: 'select_driver'
    elsif locale == :fa 
      return redirect_to action: 'select_date_format'
    else
      return redirect_to action: 'select_period'
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
      redirect_to action: 'select_period'   
    end
  end

  def select_date_format
  end

  def accept_date_format
    session[:date_format] = params[:date_format]
    redirect_to action: 'select_period'
  end

  def select_period
    if locale == :en
      session[:date_format] = nil
    end
  end

  def accept_period
    if params[:period] == "periodic"
      if params[:days].nil?
        flash[:error] = t "flash.choose_a_day"
        redirect_to action: 'select_period'
        return false
      end
      session[:weeks] = params[:weeks]
      session[:days]  = params[:days].map{|v,s| s}
    else
      params[:days]   = nil
      session[:weeks] = nil
    end
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
      @trip.groupid = @trip.id
      @trip.save!

      @trip.shouts.create!(user_id: driver.id)
      
      subtrips = Subtrip.where(id: @trip.subtrips.ids)
      weeks = session[:weeks]
      if weeks
        days = session[:days]
        day =  @trip.subtrips.first.date_time
        end_date = day + (weeks.to_i * 7).days - 1.day
        while(day < end_date) do
          day = day + 1.day
          if days.include? day.wday.to_s
            temp_trip = @trip.dup
            temp_trip.save!
            temp_trip.shouts.create!(user_id: driver.id)

            subtrips.each do |subtrip|
              s = subtrip.dup
              s.date_time = day
              s.trip_id = temp_trip.id
              s.save!
            end
          end
        end        
      end
      redirect_to edit_trip_path(@trip.id) 
    else
      redirect_to new_trip_path, alert: t("error_registration") 
    end
    
  end

  def edit
     if params[:locale] == "fa"
      @date = @trip.jdate     
    else
      @date = @trip.subtrips.first.date_time.to_s(:date)
    end
    @trips = Trip.where(groupid: @trip.groupid)
  end

  def update
    respond_to do |format|
      if @trip.update(trip_params)
        if params[:group_update]
          @trip.subtrips.each do |subtrip|
            Trip.where(groupid: @trip.groupid).each do |trip|
              trip.detail = @trip.detail
              trip.save!
              subs_for_change = trip.subtrips.where(olat: subtrip.olat, dlat: subtrip.dlat).where("date_time > ?", DateTime.now)
              subs_for_change.each do |s|
                s.price = subtrip.price
                s.active = subtrip.active
                s.save!
              end              
            end
          end
        end
        format.html { redirect_to [:edit, @trip] }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if params[:group_delete]
      @trip.sisters.destroy_all
    else
      @trip.destroy
      sister_trip = @trip.sisters.first
    end
    respond_to do |format|
      if sister_trip
        format.html { redirect_to edit_trip_path(sister_trip), notice: t("trip_delete_message") }
      elsif current_user.owned_branch
        format.html { redirect_to [current_user.owned_branch.company, current_user.owned_branch], notice: t("trip_delete_message") }
      else
        format.html { redirect_to trips_path, notice: t("trip_delete_message") }
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
        subtrips_attributes: [:id, :price, :seats, :active, :_destroy,
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

    def reset_sessions
      session[:driver_id] = nil
      session[:date_format] = nil
      session[:weeks] = nil
      session[:days]  = nil
    end
end
