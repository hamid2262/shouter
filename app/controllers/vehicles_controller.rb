class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:edit, :update, :destroy]

  load_and_authorize_resource 
  skip_load_resource only: [:create] 

  def new
    @vehicle = Vehicle.new
  end

  def edit
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    respond_to do |format|
      if @vehicle.valid?
      	current_user.vehicle = @vehicle
        if session[:return_to].present?
          redirect_to session.delete(:return_to)
          return false
        end         	
        format.html { redirect_to user, notice: 'Vehicle was successfully created.' }
        format.json { render action: 'show', status: :created, location: @vehicle }
      else
        format.html { render action: 'new' }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.html { redirect_to user, notice: 'Vehicle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @vehicle.destroy
    respond_to do |format|
      format.html { redirect_to vehicles_url }
      format.json { head :no_content }
    end
  end

  private
    def set_vehicle      
      @vehicle = user.vehicle
    end

    def user
      User.find(params[:user_id])
    end

    def vehicle_params
      params.require(:vehicle).permit(:user_id, :color, :number_plate, :air_condition, :year, :image, :vehicle_model_id)
    end
end
