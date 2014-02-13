require 'test_helper'

class NetworksControllerTest < ActionController::TestCase
  test "should get mynet" do
    get :mynet
    assert_response :success
  end

  test "should get info" do
    get :info
    assert_response :success
  end

end
