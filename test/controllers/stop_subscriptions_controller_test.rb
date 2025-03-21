require "test_helper"

class StopSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should create stop subscription" do
    user = users(:one)
    stop = stops(:one)
    post user_stop_subscriptions_path(user), params: { stop_id: stop.id }
    assert_response :redirect   # or assert_redirected_to user_path(user) if that's expected
  end

  test "should destroy stop subscription" do
    user = users(:one)
    stop = stops(:one)
    # Create the subscription first
    subscription = StopSubscription.create(user: user, stop: stop)
    delete user_stop_subscription_path(user, stop.id)
    assert_response :redirect   # or assert_redirected_to user_path(user)
  end
end
