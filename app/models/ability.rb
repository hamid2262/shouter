class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 
    if user.admin?
        can :manage, :all
    elsif user.try(:email)
        can :show, User
        can [:edit, :update], User do |u|
            user == u
        end

        can [:create, :new], Vehicle
        can [:edit, :update, :destroy], Vehicle do |v|
            user == v.user
        end

        can [:read, :create, :new], [Shout]
        can [:edit, :update, :destroy], [Shout] do |s|
            user == s.content.user
        end

        can [:manage], FollowingRelationship do |f|
            user == s.follower
        end

        can :manage, Trip
    else

    end
    
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
