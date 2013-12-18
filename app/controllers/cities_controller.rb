class CitiesController < ApplicationController

  load_and_authorize_resource
  
  before_action :set_city, only: [:show, :edit, :update, :destroy]

  def index
    @cities = City.all
  end

  def show
  end

  def new
    @city = City.new
  end

  def edit
  end

  def create
    @city = City.new(city_params)

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: 'City was successfully created.' }
        format.json { render action: 'show', status: :created, location: @city }
      else
        format.html { render action: 'new' }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @city.destroy
    respond_to do |format|
      format.html { redirect_to cities_url }
      format.json { head :no_content }
    end
  end

  def upgrade
    City.where("latitude IS NULL").each do |c|    
      begin
        c.name = c.extract_name
        c.latitude = c.extract_lat
        c.longitude = c.extract_lng
      rescue
        flash[:notice] = c.name || c.local_name
        redirect_to(:action => 'index')
        return
      end  
      c.save
    end  
    redirect_to action: "index"
  end

private
  def set_city
    # @city = City.find(params[:id])
  end

  def city_params
    params.require(:city).permit(:name,:local_name, :state_id, :latitude, :longitude)
  end

end
