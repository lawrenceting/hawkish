require 'test_helper'

class ModificationsControllerTest < ActionController::TestCase
  setup do
    @modification = modifications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:modifications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create modification" do
    assert_difference('Modification.count') do
      post :create, modification: { Tracker_id: @modification.Tracker_id, date: @modification.date, price: @modification.price }
    end

    assert_redirected_to modification_path(assigns(:modification))
  end

  test "should show modification" do
    get :show, id: @modification
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @modification
    assert_response :success
  end

  test "should update modification" do
    patch :update, id: @modification, modification: { Tracker_id: @modification.Tracker_id, date: @modification.date, price: @modification.price }
    assert_redirected_to modification_path(assigns(:modification))
  end

  test "should destroy modification" do
    assert_difference('Modification.count', -1) do
      delete :destroy, id: @modification
    end

    assert_redirected_to modifications_path
  end
end
