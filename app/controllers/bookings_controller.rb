class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:booking_acceptance]
  load_and_authorize_resource 
  skip_load_resource only: [:create] 
  skip_authorization_check only: [:booking_acceptance]
  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @subtrip = Subtrip.find(params[:trip])
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end

  def booking_acceptance
    @booking = Booking.find(params[:booking_id])
    hashed_code = params[:accept_status]
    if @booking.booking_id_check(hashed_code)
      if  @booking.booking_id_check(hashed_code) == 1
        if @booking.update_attributes(acceptance_status: 1)
          # redirect_to(@booking.subtrip, notice: "user successfully booked the trip.")
        end
      elsif  @booking.booking_id_check(hashed_code) == -1
        if @booking.update_attributes(acceptance_status: -1)
          @data = @booking.update_all_bookings
          # return false
          # redirect_to(@booking.subtrip, notice: "user successfully rejected from the trip reservation.")
        end

      end
    else
      # error message and redirect to root path 
    end
    # give deletation message and redirect to reservation page
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @subtrip = Subtrip.find(params[:subtrip_id])
    @booking = @subtrip.bookings.build
    @booking.passenger = current_user
    @booking.take_all_conflict_seats params[:seat_numbers]

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
end
