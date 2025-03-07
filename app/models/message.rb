# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :route, optional: true
  belongs_to :stop, optional: true
  
  # Message types
  enum message_type: { delay: 0, service_change: 1, route_detour: 2, general_announcement: 3 }
  
  # Severity levels
  enum severity: { info: 0, warning: 1, critical: 2 }
  
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
    return if sent? || expired?
    
    # Determine target audience based on message type and associations
    recipients = determine_recipients
    
    # Use FCM (Firebase Cloud Messaging) for push delivery
    notification_data = {
      title: title,
      body: body,
      data: {
        message_id: id,
        message_type: message_type,
        severity: severity,
        route_id: route_id,
        stop_id: stop_id,
        expires_at: expires_at&.iso8601
      }
    }
    
    # Send the notification (implementation depends on your push service)
    PushNotificationService.deliver(recipients, notification_data)
    
    # Update sent status
    update(sent: true)
  end
  
  private
  
  def determine_recipients
    case
    when route_id.present?
      User.subscribed_to_route(route_id)
    when stop_id.present?
      User.subscribed_to_stop(stop_id)
    else
      User.subscribed_to_announcements
    end
  end
end
#message