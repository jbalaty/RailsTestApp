require 'test_helper'

class WatchedResourcesControllerTest < ActionController::TestCase
  setup do
    @watched_resource = watched_resources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:watched_resources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create watched_resource" do
    assert_difference('WatchedResource.count') do
      post :create, watched_resource: { lastCheckAt: @watched_resource.lastCheckAt, type: @watched_resource.type, urlNormalized: @watched_resource.urlNormalized, usage: @watched_resource.usage }
    end

    assert_redirected_to watched_resource_path(assigns(:watched_resource))
  end

  test "should show watched_resource" do
    get :show, id: @watched_resource
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @watched_resource
    assert_response :success
  end

  test "should update watched_resource" do
    patch :update, id: @watched_resource, watched_resource: { lastCheckAt: @watched_resource.lastCheckAt, type: @watched_resource.type, urlNormalized: @watched_resource.urlNormalized, usage: @watched_resource.usage }
    assert_redirected_to watched_resource_path(assigns(:watched_resource))
  end

  test "should destroy watched_resource" do
    assert_difference('WatchedResource.count', -1) do
      delete :destroy, id: @watched_resource
    end

    assert_redirected_to watched_resources_path
  end
end
