require 'test_helper'

class SpacialEventsControllerTest < ActionController::TestCase
  setup do
    @spacial_event = spacial_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spacial_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spacial_event" do
    assert_difference('SpacialEvent.count') do
      post :create, spacial_event: { destination_cycle: @spacial_event.destination_cycle, destination_id: @spacial_event.destination_id, end_date: @spacial_event.end_date, image: @spacial_event.image, origin_cycle: @spacial_event.origin_cycle, origin_id: @spacial_event.origin_id, permalink: @spacial_event.permalink, start_date: @spacial_event.start_date, title: @spacial_event.title }
    end

    assert_redirected_to spacial_event_path(assigns(:spacial_event))
  end

  test "should show spacial_event" do
    get :show, id: @spacial_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spacial_event
    assert_response :success
  end

  test "should update spacial_event" do
    patch :update, id: @spacial_event, spacial_event: { destination_cycle: @spacial_event.destination_cycle, destination_id: @spacial_event.destination_id, end_date: @spacial_event.end_date, image: @spacial_event.image, origin_cycle: @spacial_event.origin_cycle, origin_id: @spacial_event.origin_id, permalink: @spacial_event.permalink, start_date: @spacial_event.start_date, title: @spacial_event.title }
    assert_redirected_to spacial_event_path(assigns(:spacial_event))
  end

  test "should destroy spacial_event" do
    assert_difference('SpacialEvent.count', -1) do
      delete :destroy, id: @spacial_event
    end

    assert_redirected_to spacial_events_path
  end
end
