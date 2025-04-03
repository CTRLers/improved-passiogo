class Driver < User
  # Association with the active route the driver is currently driving
  belongs_to :active_route, class_name: 'Route', optional: true
  
  # Update the current stop of the driver's active route
  def update_current_stop(stop)
    return false unless active_route
    
    # Verify the stop belongs to this route
    if active_route.stops.include?(stop)
      # Update the route's current stop
      active_route.update(current_stop: stop)
      
      # Create a message to notify subscribers about the update
      active_route.messages.create(
        content: "Bus is now at stop: #{stop.name}",
        message_type: "location_update"
      )
      
      # Notify stop subscribers
      stop.messages.create(
        content: "Bus has arrived at this stop",
        message_type: "arrival_notification"
      )
      
      return true
    else
      return false
    end
  end
  
  # Move to the next stop in sequence
  def move_to_next_stop
    return false unless active_route && active_route.current_stop
    
    # Find all stops for this route
    stops = active_route.stops.order(:position) # Assuming stops have a position attribute
    # Alternative ordering if no position attribute exists:
    # stops = active_route.stops.order(:id)
    
    current_index = stops.find_index(active_route.current_stop)
    return false if current_index.nil?
    
    next_stop = stops[current_index + 1]
    
    if next_stop
      update_current_stop(next_stop)
    else
      # Handle end of route
      active_route.messages.create(
        content: "Bus has completed the route",
        message_type: "route_completed"
      )
      
      # Optionally reset current_stop to nil at end of route
      # active_route.update(current_stop: nil)
      
      false
    end
  end
  
  # Start a route from the beginning
  def start_route
    return false unless active_route
    
    first_stop = active_route.stops.order(:position).first
    if first_stop
      update_current_stop(first_stop)
    else
      false
    end
  end
  
  # Get the next stop information without updating
  def next_stop
    return nil unless active_route && active_route.current_stop
    
    stops = active_route.stops.order(:position)
    current_index = stops.find_index(active_route.current_stop)
    return nil if current_index.nil?
    
    stops[current_index + 1]
  end
  
  # Check if this is the last stop
  def last_stop?
    return false unless active_route && active_route.current_stop
    
    stops = active_route.stops.order(:position)
    current_index = stops.find_index(active_route.current_stop)
    return false if current_index.nil?
    
    current_index == stops.length - 1
  end
end
