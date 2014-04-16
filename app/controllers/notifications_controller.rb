class NotificationsController < ApplicationController
  authorize_resource 
	
  def index
  	# @notifications = @notificationable.notifications
  end

  private

end
