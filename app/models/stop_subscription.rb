class StopSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :stop
  
  validates :user_id, uniqueness: { scope: :stop_id, message: "is already subscribed to this stop" }
end
#for users