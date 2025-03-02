
class Message < ApplicationRecord
  belongs_to :route, optional: true
  belongs_to :stop, optional: true
  
  # Message types
  enum message_type: {
    delay: 0,
    service_change: 1,
    route_detour: 2,
    general_announcement: 3
  }
  
  # Severity levels
  enum severity: {
    info: 0,
    warning: 1,
    critical: 2
  }
  
  # Validations
  validates :title, presence: true
  validates :body, presence: true
  validates :message_type, presence: true
  validates :severity, presence: true
  
  # Scopes
  scope :active, -> { where('expires_at > ?', Time.current) }
  scope :for_route, ->(route_id) { where(route_id: route_id) }
  scope :for_stop, ->(stop_id) { where(stop_id: stop_id) }
  
  # Methods
  def expired?
    expires_at.present? && expires_at < Time.current
  end
  
  def send_push_notification
    # Implement push notification logic here
    # You might want to use a service like Firebase Cloud Messaging,
    # OneSignal, or another push notification service
  end
end
