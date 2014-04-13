class SuperadminsController < ApplicationController

  skip_authorization_check
  def index
  end

  def trips
  	@trips = Trip.last(30).reverse
  end

  def messages
  	@messages = Message.last(30).reverse
  end
end
