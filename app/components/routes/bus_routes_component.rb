# frozen_string_literal: true

class Routes::BusRoutesComponent < ViewComponent::Base
  def initialize(routes:)
    @routes = routes
  end
end
