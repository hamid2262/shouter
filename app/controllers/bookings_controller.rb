class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:booking_acceptance]
  load_and_authorize_resource 
  # skip_load_resource only: [:create] 
  skip_authorization_check only: [:booking_acceptance]
  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = current_user.bookings.order(created_at: :desc)
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    check_for_mobile
    @subtrip = Subtrip.find(params[:trip])
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end

  def booking_acceptance
    @booking = Booking.find(params[:booking_id])
    @subtrip = @booking.subtrip
    unless @booking.acceptance_status == 0
      @already_replied = 1
      return false 
    end
    hashed_code = params[:accept_status]

    if @booking.booking_id_check(hashed_code)
      if  @booking.booking_id_check(hashed_code) == 1
        if @booking.update_attributes(acceptance_status: 1)
          UserMailer.booking_positive_response_to_passenger(@booking).deliver
        end
      elsif  @booking.booking_id_check(hashed_code) == -1
        if @booking.update_attributes(acceptance_status: -1)
          @booking.update_all_bookings
          UserMailer.booking_negative_response_to_passenger(@booking).deliver
        end
      end #@booking.booking_id_check(hashed_code) == -1
    else
      redirect_to root_path, notice: t('unauthorized_pages_message') 
    end #@booking.booking_id_check(hashed_code)
    # give deletation message and redirect to reservation page
    @booking = Booking.find(params[:booking_id])
    @subtrip = @booking.subtrip
  end

  def create
    @subtrip = Subtrip.find(params[:subtrip_id])
    if check_for_ladies_only
      flash[:error] = 'Not allowed to access to this section'
      redirect_to root_path
      return false
    end
    @booking = @subtrip.bookings.build
    @booking.passenger = current_user
    @booking.subtrip.take_all_conflict_seats params[:seat_numbers], @booking.passenger.id

    respond_to do |format|
      if @booking.save
        UserMailer.booking_request_to_driver(@booking).deliver
        format.html { redirect_to @subtrip, notice: t(:booking_created_message) }
        format.json { render action: 'show', status: :created, location: @booking }
      else
        format.html { render action: 'new' }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: t(:booking_updated_message) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.update_all_bookings
    @booking.destroy    
    respond_to do |format|
      format.html { redirect_to bookings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:passenger_id, :acceptance_status)
    end
    def subtrip_params
      params.require(:subtrip).permit(:seats)
    end

    def check_for_ladies_only
      current_user.gender == 'm' && @subtrip.trip.ladies_only
    end
end
