# frozen_string_literal: true

require "test_helper"

class Routes::RouteCardComponentTest < ViewComponent::TestCase
  def test_component_renders_correctly
    sample_route = {
      "id" => "1",
      "name" => "Test Route",
      "latitude" => "28.000",
      "longitude" => "-82.000"

    }

    # Create a stubbed helpers object that returns stops when fetch_stops is called.
    stubbed_helpers = Object.new.tap do |obj|
      def obj.fetch_stops(id)
        # Return stops regardless of the passed id.
        [ { "name" => "Stop 1" }, { "name" => "Stop 2" } ]
      end
    end

    # Create the component instance.
    component = Routes::RouteCardComponent.new(route: sample_route)
    # Override the component's helpers method.
    component.define_singleton_method(:helpers) { stubbed_helpers }

    render_inline(component)

    # Assert that the component renders the expected content.
    assert_text "Route: Test Route"
    assert_text "Coordinates: 28.000, -82.000"
    assert_text "Number of Stops: 2"
    assert_text "Stop 1"
    assert_text "Stop 2"
  end
end
