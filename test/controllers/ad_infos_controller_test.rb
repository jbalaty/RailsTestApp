require 'test_helper'

class AdInfosControllerTest < ActionController::TestCase
  setup do
    @ad_info = ad_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ad_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ad_info" do
    assert_difference('AdInfo.count') do
      post :create, ad_info: { externid: @ad_info.externid, urlNormalized: @ad_info.urlNormalized }
    end

    assert_redirected_to ad_info_path(assigns(:ad_info))
  end

  test "should show ad_info" do
    get :show, id: @ad_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ad_info
    assert_response :success
  end

  test "should update ad_info" do
    patch :update, id: @ad_info, ad_info: { externid: @ad_info.externid, urlNormalized: @ad_info.urlNormalized }
    assert_redirected_to ad_info_path(assigns(:ad_info))
  end

  test "should destroy ad_info" do
    assert_difference('AdInfo.count', -1) do
      delete :destroy, id: @ad_info
    end

    assert_redirected_to ad_infos_path
  end
end
