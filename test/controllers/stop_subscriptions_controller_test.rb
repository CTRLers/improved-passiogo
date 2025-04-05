require "test_helper"

class StopSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @stop = stops(:one)   # Ensure you have a valid stop fixture in test/fixtures/stops.yml.
  end

  test "should create stop subscription" do
    assert_difference "StopSubscription.count", 1 do
      post user_stop_subscriptions_path(@user), params: { stop_subscription: { stop_id: @stop.id } }
    end
    assert_redirected_to user_path(@user)
  end

  test "should destroy stop subscription" do
    subscription = @user.stop_subscriptions.create!(stop: @stop)
    assert_difference "StopSubscription.count", -1 do
      delete user_stop_subscription_path(@user, subscription)
    end
    assert_redirected_to user_path(@user)
  end
end
