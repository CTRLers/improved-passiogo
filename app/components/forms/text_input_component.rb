# frozen_string_literal: true

class Forms::TextInputComponent < ViewComponent::Base
  # app/components/forms/text_input_component.rb
  def initialize(form:, field:, label:, field_type: :text_field, classes: "w-full border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:border-apple focus:ring-apple dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400", placeholder: nil)
    @form = form
    @field = field
    @label = label
    @field_type = field_type
    @classes = classes
    @placeholder = placeholder
  end

  attr_reader :form, :field, :label, :field_type, :classes, :placeholder
end
