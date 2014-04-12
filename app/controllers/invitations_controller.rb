class InvitationsController < ApplicationController

	load_and_authorize_resource

  def show
  end

  def create
    InvitationMailer.invite(current_user, params[:email]).deliver
    redirect_to invitation_path, notice: t("invitation_send_message", email: params[:email])
  end

  def invite_acceptation
  	@inviter = User.where(slug: params[:inviter]).first
  	session[:inviter] = @inviter.id
  	redirect_to new_user_registration_path, notice: t('.invited_user_welcome_message', name: @inviter.name)
  end
end
