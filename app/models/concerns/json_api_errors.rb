# frozen_string_literal: true

module JsonApiErrors
  extend ActiveSupport::Concern

  def full_messages
    errors.messages.map do |attribute, error_messages|
      error_messages.map do |error_message|
        {
          status: '422',
          source: { pointer: "/data/attributes/#{attribute}" },
          title: error_message,
          detail: error_message
        }
      end
    end.flatten
  end
end
