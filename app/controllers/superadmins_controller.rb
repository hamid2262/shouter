class SuperadminsController < ApplicationController

  skip_authorization_check
  def index
  end

  def trips
  	@trips = Trip.last(5)
  end

  def messages
  end
end
