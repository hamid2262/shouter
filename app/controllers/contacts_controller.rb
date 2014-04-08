class ContactsController < ApplicationController
  layout 'application_user'
  authorize_resource
  before_filter :authenticate_user!
 
  # before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    @message    = Message.new
# raise
    # @receiver   = User.where(slug: params[:id]).first
    @receiver   = current_user.contacts.last
    receiver_id = @receiver.id if @receiver
    @contacts   = Contact.where("sender_id = ? AND receiver_id = ? OR sender_id = ? AND receiver_id = ?", current_user.id, receiver_id, receiver_id, current_user.id)
    @contact    =  Contact.where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id).last
    @messages   = Message.where(contact_id: @contacts.ids)
    @contact_list =  current_user.contacts

  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  	@message    = Message.new
  	@receiver   = User.where(slug: params[:id]).first
  	receiver_id = @receiver.id
    @contact    =  Contact.where(sender_id: current_user.id, receiver_id: receiver_id).first_or_create!
  	@contacts   = Contact.where("sender_id = ? AND receiver_id = ? OR sender_id = ? AND receiver_id = ?", current_user.id, receiver_id, receiver_id, current_user.id)
  	@messages   = Message.where(contact_id: @contacts.ids)
    @contact_list =  current_user.contacts
  end

  # GET /contacts/new

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
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
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
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
