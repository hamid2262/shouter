require 'test_helper'

class TransportationCompaniesControllerTest < ActionController::TestCase
  setup do
    @transportation_company = transportation_companies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transportation_companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transportation_company" do
    assert_difference('TransportationCompany.count') do
      post :create, transportation_company: { email: @transportation_company.email, name: @transportation_company.name, tel: @transportation_company.tel }
    end

    assert_redirected_to transportation_company_path(assigns(:transportation_company))
  end

  test "should show transportation_company" do
    get :show, id: @transportation_company
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transportation_company
    assert_response :success
  end

  test "should update transportation_company" do
    patch :update, id: @transportation_company, transportation_company: { email: @transportation_company.email, name: @transportation_company.name, tel: @transportation_company.tel }
    assert_redirected_to transportation_company_path(assigns(:transportation_company))
  end

  test "should destroy transportation_company" do
    assert_difference('TransportationCompany.count', -1) do
      delete :destroy, id: @transportation_company
    end

    assert_redirected_to transportation_companies_path
  end
end
