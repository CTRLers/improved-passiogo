class User < ApplicationRecord
  # Include default devise modules if you're using Devise for authentication
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  
  # Associations
  has_many :route_subscriptions, dependent: :destroy
  has_many :stop_subscriptions, dependent: :destroy
  has_many :subscribed_routes, through: :route_subscriptions, source: :route
  has_many :subscribed_stops, through: :stop_subscriptions, source: :stop
  
  # Notification preferences 
  # This assumes your users table has a jsonb/json column named 'preferences'
  store_accessor :preferences, :receive_announcements, :receive_delay_notifications
  
  # FCM token for push notifications
  validates :fcm_token, uniqueness: true, allow_nil: true
  
  # Basic validations (adjust based on your authentication system)
  validates :email, presence: true, uniqueness: true
  
  # Scopes for finding users interested in specific notifications
  scope :subscribed_to_route, ->(route_id) { 
    joins(:route_subscriptions).where(route_subscriptions: { route_id: route_id })
      .where("preferences->>'receive_delay_notifications' != ?", 'false')
  }
  
  scope :subscribed_to_stop, ->(stop_id) { 
    joins(:stop_subscriptions).where(stop_subscriptions: { stop_id: stop_id })
      .where("preferences->>'receive_delay_notifications' != ?", 'false')
  }
  
  scope :subscribed_to_announcements, -> { 
    where("preferences->>'receive_announcements' != ?", 'false')
  }
  
  # Set default preferences for new users
  after_initialize :set_default_preferences, if: :new_record?
  
  # Method to update FCM token
  def update_fcm_token(token)
    update(fcm_token: token)
  end
  
  # Subscribe to a route
  def subscribe_to_route(route)
    subscribed_routes << route unless subscribed_to_route?(route)
  end
  
  # Unsubscribe from a route
  def unsubscribe_from_route(route)
    subscribed_routes.delete(route)
  end
  
  # Check if subscribed to a route
  def subscribed_to_route?(route)
    subscribed_routes.include?(route)
  end
  
  # Subscribe to a stop
  def subscribe_to_stop(stop)
    subscribed_stops << stop unless subscribed_to_stop?(stop)
  end
  
  # Unsubscribe from a stop
  def unsubscribe_from_stop(stop)
    subscribed_stops.delete(stop)
  end
  
  # Check if subscribed to a stop
  def subscribed_to_stop?(stop)
    subscribed_stops.include?(stop)
  end
  
  private
  
  def set_default_preferences
    self.preferences ||= {}
    self.preferences[:receive_announcements] = true if self.preferences[:receive_announcements].nil?
    self.preferences[:receive_delay_notifications] = true if self.preferences[:receive_delay_notifications].nil?
  end
end
