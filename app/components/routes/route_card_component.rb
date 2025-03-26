# frozen_string_literal: true

class Routes::RouteCardComponent < ViewComponent::Base
  def initialize(route:)
    @route = route
  end
end
