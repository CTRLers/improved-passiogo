require "rails_helper"

RSpec.describe "User Account Deletion", type: :request do
  let!(:user) { create(:user) } # Create a user for testing

  describe "DELETE /users/:id" do
    it "deletes the user and all associated data" do
      # Count initial user and related subscriptions
      initial_user_count = User.count
      initial_route_subscriptions_count = RouteSubscription.count
      initial_stop_subscriptions_count = StopSubscription.count

      # Send the DELETE request to the user path
      delete user_path(user)

      # Reload the user from the database (after deletion)
      expect(User.count).to eq(initial_user_count - 1) # One less user
      expect(RouteSubscription.count).to eq(initial_route_subscriptions_count - user.route_subscriptions.count) # Subscriptions removed
      expect(StopSubscription.count).to eq(initial_stop_subscriptions_count - user.stop_subscriptions.count) # Stop subscriptions removed

      # Ensure response status is 200 (OK)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Account deleted successfully")
    end
  end
end
