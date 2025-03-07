#Notiffication
class PushNotificationService
  include Singleton
  
  def self.deliver(recipients, notification_data)
    instance.deliver(recipients, notification_data)
  end
  
  def deliver(recipients, notification_data)
    # Initialize Firebase (adjust based on your setup)
    fcm = FCM.new(Rails.application.credentials.firebase[:server_key])
    
    # Get registration tokens for recipients
    registration_tokens = recipients.map(&:fcm_token).compact
    
    # Skip if no valid tokens
    return if registration_tokens.empty?
    
    # Prepare notification payload
    options = {
      priority: 'high',
      notification: {
        title: notification_data[:title],
        body: notification_data[:body]
      },
      data: notification_data[:data]
    }
    
    # Send to Firebase
    response = fcm.send(registration_tokens, options)
    
    # Log results
    log_delivery_results(response, registration_tokens.count)
    
    response
  end
  
  private
  
  def log_delivery_results(response, recipient_count)
    success_count = response[:success] || 0
    failure_count = response[:failure] || 0
    
    Rails.logger.info "[PushNotification] Sent to #{recipient_count} recipients. Success: #{success_count}, Failure: #{failure_count}"
    
    if response[:failed_registration_ids]&.any?
      Rails.logger.warn "[PushNotification] Failed tokens: #{response[:failed_registration_ids].join(', ')}"
    end
  end
end
