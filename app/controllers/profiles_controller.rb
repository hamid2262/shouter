class ProfilesController < ApplicationController  
  layout 'application_user', only: [:show]
	
	# before_filter :authenticate_user!
	skip_authorization_check

	def show
        if locale == :fa && request.url[-3,3]== "/en"
            u = request.url.gsub! "/en", "/fa"
            redirect_to u
        end
		@user                   = User.find_by!(slug: params[:id])
        if @user.active == false
            flash[:error] = "کاربر مورد نظر غیر فعال است."
            redirect_to root_path
        end
		@profile                = Profile.new(@user)
        @timeline               = @profile.timeline.page(params[:page]).per_page(5)

        @nearest_trips          = @profile.nearest_trips.first(5)

        @followed_users         = @profile.followed_users
        @followers              = @profile.followers
        @random_users           = @profile.random_users
            
        @bookings_count         = @profile.bookings_count
        @trips_count            = @profile.trips_count
        @booking_canceled_count = @profile.booking_canceled_count
        @trip_canceled_count    = @profile.trip_canceled_count

        @vehicle = @user.vehicle      
	end

    def all_trips
        @user          = User.find_by!(slug: params[:id])
        @profile       = Profile.new(@user)
        @nearest_trips = @profile.nearest_trips        
    end
end
