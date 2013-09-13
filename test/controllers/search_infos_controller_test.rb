require 'test_helper'

class SearchInfosControllerTest < ActionController::TestCase
  setup do
    @search_info = search_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:search_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create search_info" do
    assert_difference('SearchInfo.count') do
      post :create, search_info: {  }
    end

    assert_redirected_to search_info_path(assigns(:search_info))
  end

  test "should show search_info" do
    get :show, id: @search_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @search_info
    assert_response :success
  end

  test "should update search_info" do
    patch :update, id: @search_info, search_info: {  }
    assert_redirected_to search_info_path(assigns(:search_info))
  end

  test "should destroy search_info" do
    assert_difference('SearchInfo.count', -1) do
      delete :destroy, id: @search_info
    end

    assert_redirected_to search_infos_path
  end
end
