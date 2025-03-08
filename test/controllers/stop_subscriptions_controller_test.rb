require "test_helper"

class StopSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should create stop subscription" do
    user = users(:one)
    stop = stops(:one)
    assert_difference('StopSubscription.count', 1) do
      post user_stop_subscriptions_path(user, stop_id: stop.id)
    end
    assert_redirected_to user
  end

  test "should destroy stop subscription" do
    user = users(:one)
    stop = stops(:one)
    user.subscribe_to_stop(stop)  # Ensure a subscription exists
    assert_difference('StopSubscription.count', -1) do
      delete user_stop_subscription_path(user, stop_id: stop.id)
    end
    assert_redirected_to user
  end
end
