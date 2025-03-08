require "test_helper"

class StopSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get stop_subscriptions_create_url
    assert_response :success
  end

  test "should get destroy" do
    get stop_subscriptions_destroy_url
    assert_response :success
  end
end
