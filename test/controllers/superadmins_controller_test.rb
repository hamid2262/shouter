require 'test_helper'

class SuperadminsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get trips" do
    get :trips
    assert_response :success
  end

  test "should get messages" do
    get :messages
    assert_response :success
  end

end
