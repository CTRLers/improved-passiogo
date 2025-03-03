require "test_helper"

class RouteSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get route_subscriptions_create_url
    assert_response :success
  end

  test "should get destroy" do
    get route_subscriptions_destroy_url
    assert_response :success
  end
end
