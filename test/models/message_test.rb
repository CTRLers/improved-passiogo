require "test_helper"

class MessageTest < ActiveSupport::TestCase
  def setup
    # Create a sample messageable for testing.
    # Replace attributes with the minimal required for your models.
    @route = Route.create!(name: "Test Route", latitude: 1.23, longitude: 4.56)
    # Create a Stop record that belongs to the Route.
    @stop  = Stop.create!(name: "Test Stop", latitude: 1.23, longitude: 4.56, route: @route)
  end

  test "should save valid message with route" do
    message = Message.new(
      message_type: "info",
      content: "This is a test message for route",
      messageable: @route
    )
    assert message.save, "Message with valid attributes for route should be saved"
  end

  test "should save valid message with stop" do
    message = Message.new(
      message_type: "alert",
      content: "This is a test message for stop",
      messageable: @stop
    )
    assert message.save, "Message with valid attributes for stop should be saved"
  end

  test "should not save message without message_type" do
    message = Message.new(
      content: "Missing message type",
      messageable: @route
    )
    assert_not message.save, "Saved the message without a message_type"
  end

  test "should not save message without content" do
    message = Message.new(
      message_type: "info",
      messageable: @route
    )
    assert_not message.save, "Saved the message without content"
  end

  test "should not save message without messageable" do
    message = Message.new(
      message_type: "info",
      content: "No messageable associated"
    )
    assert_not message.save, "Saved the message without a messageable"
  end
end
