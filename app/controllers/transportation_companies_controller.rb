class TransportationCompaniesController < ApplicationController
  before_action :set_transportation_company, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource 
  skip_load_resource only: [:create] 
  
  # GET /transportation_companies
  # GET /transportation_companies.json
  def index
    @transportation_companies = TransportationCompany.all
  end

  # GET /transportation_companies/1
  # GET /transportation_companies/1.json
  def show
  end

  # GET /transportation_companies/new
  def new
    @transportation_company = TransportationCompany.new
  end

  # GET /transportation_companies/1/edit
  def edit
  end

  # POST /transportation_companies
  # POST /transportation_companies.json
  def create
    @transportation_company = TransportationCompany.new(transportation_company_params)

    respond_to do |format|
      if @transportation_company.save
        format.html { redirect_to @transportation_company, notice: 'Transportation company was successfully created.' }
        format.json { render action: 'show', status: :created, location: @transportation_company }
      else
        format.html { render action: 'new' }
        format.json { render json: @transportation_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transportation_companies/1
  # PATCH/PUT /transportation_companies/1.json
  def update
    respond_to do |format|
      if @transportation_company.update(transportation_company_params)
        format.html { redirect_to @transportation_company, notice: 'Transportation company was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @transportation_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transportation_companies/1
  # DELETE /transportation_companies/1.json
  def destroy
    @transportation_company.destroy
    respond_to do |format|
      format.html { redirect_to transportation_companies_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transportation_company
      @transportation_company = TransportationCompany.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transportation_company_params
      params.require(:transportation_company).permit(:name,:slug, :tel, :email,:website, :image, :cover)
    end
end
