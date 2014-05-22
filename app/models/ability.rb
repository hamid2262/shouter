class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 
    if user.admin?
        can :manage, :all
        can :access, :ckeditor 
        can [:read, :create, :destroy], Ckeditor::Picture
        can [:read, :create, :destroy], Ckeditor::AttachmentFile
    elsif user.try(:email) != ""
        
        can [:edit, :update], Branch do |b|
            user == b.manager
        end

        can [:manage], BranchDriverRelationship 

        can [:edit, :update, :refresh], User do |u|
            user == u
        end

        can [:new, :create], Comment

        can [:read, :create, :new], [Shout, PhotoShout]
        can [:edit, :update, :destroy], [Shout, PhotoShout] do |s|
            user == s.shouts.first.user
        end

        can [:manage], FollowingRelationship 

        can [:new, :create, :index, :show ,:select_driver, :accept_driver,:select_date_format,:accept_date_format,  :select_period, :accept_period], Trip

        can [:edit, :update], Subtrip do |s|
            (user == s.trip.driver) || (s.trip.driver.branches.map{|b| b.manager}.include? user)
        end

        can [:edit, :update, :destroy], Trip do |t|
           ( (user == t.driver) || (t.driver.branches.map{|b| b.manager}.include? user) )&& (t.subtrips.first.date_time > DateTime.now + 3.hours)
        end        

        can [:new, :create, :index], Booking
        can [:booking_response], Booking do |b|
            [b.subtrip.trip.driver, b.subtrip.trip.driver.branches.map{|branch| branch.manager}].flatten.include? user
        end
        can [:destroy], Booking do |b|
            (user == b.passenger) && (b.acceptance_status != -1) && (b.subtrip.date_time > DateTime.now + 3.hours)
        end
        
        can [:show, :create], Invitation
        
        can [:new, :create], Vehicle
        can [:edit, :update], Vehicle do |v|
            user == v.user
        end

        can [:show], Network

        can [:create], Message
        can [:create, :show], Contact
        can [:index, :update], Contact do |m|
            user = m
        end
    else
        can :invite_acceptation, Invitation
    end

    can [:index], Contact

    can :show, Vehicle
    can :show, Branch
    can :show, Company
    can :show, SpacialEvent
    can :show, User
    can [:start_new_trip], Trip
    can [:show], Subtrip
    can :booking_acceptance, Booking
    can [:show, :contact, :contact_accept, :company_account_request, :company_account_request_accept], Page
  end
end
