require 'test_helper'

class PageFoldersControllerTest < ActionController::TestCase
  setup do
    @page_folder = page_folders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:page_folders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page_folder" do
    assert_difference('PageFolder.count') do
      post :create, page_folder: {  }
    end

    assert_redirected_to page_folder_path(assigns(:page_folder))
  end

  test "should show page_folder" do
    get :show, id: @page_folder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @page_folder
    assert_response :success
  end

  test "should update page_folder" do
    patch :update, id: @page_folder, page_folder: {  }
    assert_redirected_to page_folder_path(assigns(:page_folder))
  end

  test "should destroy page_folder" do
    assert_difference('PageFolder.count', -1) do
      delete :destroy, id: @page_folder
    end

    assert_redirected_to page_folders_path
  end
end
