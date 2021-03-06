class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # GET /pages/contact
  def contact
  end

  # POST /pages/contact_accept
  def contact_accept
    AdminMailer.contact_us(params[:contact]).deliver
    flash[:notice] = t(".contact_us_sent")
    redirect_to action: "contact"
    return false
  end

  # GET /pages/company_account_request
  def company_account_request
  end

  # POST /pages/company_account_request_accept
  def company_account_request_accept
    AdminMailer.company_account_request(params[:request]).deliver
    flash[:notice] = t(".company_account_request_sent")
    redirect_to action: "company_account_request"
    return false
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render action: 'show', status: :created, location: @page }
      else
        format.html { render action: 'new' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find_by!(permalink: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:name, :permalink, :content)
    end
end
