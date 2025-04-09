# frozen_string_literal: true

class Forms::RegistrationFormComponent < ViewComponent::Base
  def initialize(resource:, resource_name:, devise_mapping:, minimum_password_length: nil)
    @resource = resource
    @resource_name = resource_name
    @devise_mapping = devise_mapping
    @minimum_password_length = minimum_password_length
  end

  attr_reader :resource, :resource_name, :devise_mapping, :minimum_password_length
end
