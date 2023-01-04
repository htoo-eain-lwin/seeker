# frozen_string_literal: true

module Layout
  class FlashComponent < ApplicationComponent
    attr_reader :flash

    include ActiveSupport::Inflector

    TYPES_TO_SHOW = %w[notice error alert].freeze

    def initialize(flash)
      @flash = flash
      super
    end

    def flashes
      flash.filter { |key, _msg| TYPES_TO_SHOW.include? key }
    end

    def class_name(type)
      case type
      when 'notice'
        'alert-info'
      when 'error'
        'alert-danger'
      else
        'alert-secondary'
      end
    end

    def icon(type)
      type == 'notice' ? 'fa fa-info-circle' : 'fa fa-times-circle'
    end
  end
end
