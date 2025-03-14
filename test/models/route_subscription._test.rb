require 'test_helper'

class RouteSubscriptionTest < ActiveSupport::TestCase
  test "should belong to a user" do
    route_subscription = RouteSubscription.new
    assert_respond_to route_subscription, :user
  end

  test "should belong to a route" do
    route_subscription = RouteSubscription.new
    assert_respond_to route_subscription, :route
  end

  test "should not allow duplicate subscriptions for the same user and route" do
    user = users(:one)
    route = routes(:one)
    
    # Create the first subscription
    first_subscription = RouteSubscription.create(user: user, route: route)
    assert first_subscription.valid?
    
    # Try to create a duplicate subscription
    duplicate_subscription = RouteSubscription.new(user: user, route: route)
    assert_not duplicate_subscription.valid?
    assert_includes duplicate_subscription.errors.messages[:user_id], "is already subscribed to this route"
  end

  test "should allow a user to subscribe to different routes" do
    user = users(:one)
    route1 = routes(:one)
    route2 = routes(:two)
    
    # Subscribe to the first route
    subscription1 = RouteSubscription.create(user: user, route: route1)
    assert subscription1.valid?
    
    # Subscribe to the second route
    subscription2 = RouteSubscription.new(user: user, route: route2)
    assert subscription2.valid?
  end

  test "should allow different users to subscribe to the same route" do
    user1 = users(:one)
    user2 = users(:two)
    route = routes(:one)
    
    # First user subscribes
    subscription1 = RouteSubscription.create(user: user1, route: route)
    assert subscription1.valid?
    
    # Second user subscribes
    subscription2 = RouteSubscription.new(user: user2, route: route)
    assert subscription2.valid?
  end
end
