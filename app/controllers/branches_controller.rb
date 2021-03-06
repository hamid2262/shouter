class BranchesController < ApplicationController
  layout 'application_user', only: [:show]
  authorize_resource 
  
  before_action :set_branch, only: [:show, :edit, :update, :destroy]
  before_action :set_company

  # skip_load_resource only: [:create] 
  
  # GET /branches
  # GET /branches.json
  def index
    @branches = @company.branches
  end

  # GET /branches/1
  # GET /branches/1.json
  def show
    @timeline = @branch.timeline.page(params[:page]).per_page(10)
    begin
      @drivers = @branch.drivers
    rescue  
      redirect_to company_branch_path(company_id: params[:company_id], id: params[:branch_id])
      return false
    end
  end

  # GET /branches/new
  def new
    @branch = Branch.new
  end

  # GET /branches/1/edit
  def edit
  end

  # POST /branches
  # POST /branches.json
  def create
    @branch = Branch.new(branch_params)

    respond_to do |format|
      if @branch.save
        format.html { redirect_to [@company, @branch], notice: 'Branch was successfully created.' }
        format.json { render action: 'show', status: :created, location: @branch }
      else
        format.html { render action: 'new' }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /branches/1
  # PATCH/PUT /branches/1.json
  def update
    respond_to do |format|
      if @branch.update(branch_params)
        format.html { redirect_to [@company, @branch], notice: 'Branch was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1
  # DELETE /branches/1.json
  def destroy
    @branch.destroy
    respond_to do |format|
      format.html { redirect_to company_branches_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_branch
      @branch = Branch.where(slug: params[:id]).first
    end

    def set_company
      @company = Company.where(slug: params[:company_id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def branch_params
      params.require(:branch).permit(:name, :slug, :address, :email, :tel, :mobile, :city,:company_id, :user_id, :cover)
    end
end
