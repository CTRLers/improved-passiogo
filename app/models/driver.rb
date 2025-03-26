class Driver < User
  # Optional: Ensure that the driver flag is set to true (if you have a driver boolean column)
  after_initialize :set_driver_flag

  private

  def set_driver_flag
    # Only set if the attribute exists
    self.driver = true if has_attribute?(:driver) && self.driver != true
  end
end
