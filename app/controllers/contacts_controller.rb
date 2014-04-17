class ContactsController < ApplicationController
  layout 'application_user'
  authorize_resource
  before_filter :authenticate_user!
 
  # before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    if current_user.last_contacted_user
      redirect_to contact_path(current_user.last_contacted_user.slug)
      return false
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  	@message    = Message.new
  	@receiver   ||= User.where(slug: params[:id]).first
    @contact    ||= Contact.where(sender_id: current_user.id, receiver_id: @receiver.id).first_or_create!
  	@messages   ||= Message.where(contact_id: current_user.contacts_with(@receiver).ids).last(20)

    @contacted_users =  current_user.contacted_users
    
    @contact_otherside = @receiver.contact_to current_user
    if @contact_otherside
      @contact_otherside.receiver_saw = true
      @contact_otherside.save!
    end

  end

  # GET /contacts/new

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact }
        format.json { render action: 'show', status: :created, location: @contact }
      else
        format.html { render action: 'new' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:contact_id, :body, :hide4sender, :hide4receiver)
    end

end
