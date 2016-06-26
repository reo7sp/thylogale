require 'test_helper'

class FirstSetupsControllerTest < ActionController::TestCase
  setup do
    @first_setup = first_setups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:first_setups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create first_setup" do
    assert_difference('FirstSetup.count') do
      post :create, first_setup: {  }
    end

    assert_redirected_to first_setup_path(assigns(:first_setup))
  end

  test "should show first_setup" do
    get :show, id: @first_setup
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @first_setup
    assert_response :success
  end

  test "should update first_setup" do
    patch :update, id: @first_setup, first_setup: {  }
    assert_redirected_to first_setup_path(assigns(:first_setup))
  end

  test "should destroy first_setup" do
    assert_difference('FirstSetup.count', -1) do
      delete :destroy, id: @first_setup
    end

    assert_redirected_to first_setups_path
  end
end
