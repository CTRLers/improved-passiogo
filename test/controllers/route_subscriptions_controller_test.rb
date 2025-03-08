require "test_helper"

class RouteSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should create route subscription" do
    user = users(:one)
    route = routes(:one)
    assert_difference('RouteSubscription.count', 1) do
      post user_route_subscriptions_path(user, route_id: route.id)
    end
    assert_redirected_to user
  end

  test "should destroy route subscription" do
    user = users(:one)
    route = routes(:one)
    # Ensure a subscription exists first, e.g.:
    user.subscribe_to_route(route)
    assert_difference('RouteSubscription.count', -1) do
      delete user_route_subscription_path(user, route_id: route.id)
    end
    assert_redirected_to user
  end

end
