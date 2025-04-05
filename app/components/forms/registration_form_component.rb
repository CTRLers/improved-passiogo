# frozen_string_literal: true

class Forms::RegistrationFormComponent < ViewComponent::Base
  def initialize(resource:, resource_name:, devise_mapping:)
    @resource = resource
    @resource_name = resource_name
    @devise_mapping = devise_mapping
  end

  attr_reader :resource, :resource_name, :devise_mapping
end
