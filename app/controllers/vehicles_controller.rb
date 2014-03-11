class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:edit, :update, :destroy]
  
  before_action :user_authentication, except: [:show]
  before_action :set_user #, only: [:new, :create, :update, :edit]
  before_action :set_vehicle, only: [:update, :edit]
  skip_authorization_check 

  def new
    @vehicle = Vehicle.new
  end

  def edit
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.user = @user
    respond_to do |format|
      if @vehicle.save
        if session[:return_to].present?
          redirect_to session.delete(:return_to)
          return false
        end         	
        format.html { redirect_to_profile_with_flash( @user, t(:vehicle_create_message) ) }
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
        format.html { redirect_to_profile_with_flash( @user, t(:vehicle_update_message) ) }
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
      @vehicle = @user.vehicle
    end

    def set_user
      @user = current_user
    end

    def vehicle_params
      params.require(:vehicle).permit(:user_id, :color, :number_plate, :air_condition, :year, :image, :vehicle_model_id)
    end

    def user_authentication
      redirect_to root_url unless current_user.try(:id) == params[:user_id].to_i
    end

end
