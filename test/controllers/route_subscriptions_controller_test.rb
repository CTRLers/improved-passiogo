require "test_helper"

class RouteSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should create subscription" do
    user = users(:one)
    route = routes(:one)
    post user_route_subscriptions_path(user), params: { route_id: route.id }
    assert_redirected_to user_path(user)
  end

  test "should destroy subscription" do
    user = users(:one)
    route = routes(:one)
    # Create the subscription so it can be destroyed
    subscription = RouteSubscription.create(user: user, route: route)
    delete user_route_subscription_path(user, route.id)
    assert_redirected_to user_path(user)
  end
end
