require "test_helper"

class RouteSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user  = users(:one)   # Make sure fixture "one" exists in test/fixtures/users.yml.
    sign_in @user
    @route = routes(:one)   # Make sure fixture "one" exists in test/fixtures/routes.yml.
  end

  test "should create subscription" do
    assert_difference "RouteSubscription.count", 1 do
      post user_route_subscriptions_path(@user), params: { route_subscription: { route_id: @route.id } }
    end
    assert_redirected_to user_path(@user)
  end

  test "should destroy subscription" do
    subscription = @user.route_subscriptions.create!(route: @route)
    assert_difference "RouteSubscription.count", -1 do
      delete user_route_subscription_path(@user, subscription)
    end
    assert_redirected_to user_path(@user)
  end
end
