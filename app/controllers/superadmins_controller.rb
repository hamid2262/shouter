class SuperadminsController < ApplicationController

  skip_authorization_check
  def index
  end

  def trips
  	@trips = Trip.last(5).reverse
  end

  def messages
  	@messages = Message.last(20).reverse
  end
end
