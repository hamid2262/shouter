class MessagesController < ApplicationController
  authorize_resource
 
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @contacted_users =  current_user.contacted_users
  end

  # GET /messages/new

  # POST /messages
  # POST /messages.json
  def create
    @_contact ||= Contact.find(params[:contact_id])

    message = Message.new(message_params)
    message.contact = @_contact
    respond_to do |format|
      if message.save
        @_contact.try :touch

        @_contact.receiver_saw = false
        @_contact.save!
        if session[ params[:contact_id] ].nil?     
          session[ params[:contact_id] ] = true
          NotificationMailer.message_notification(@_contact, message).deliver
        end

        format.html { redirect_to :back }
        format.json { render action: 'show', status: :created, location: message }
      else
        format.html { render action: 'new' }
        format.json { render json: message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:contact_id, :body, :hide4sender, :hide4receiver)
    end
end
