# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

require 'spec_helper'
require 'rspec/rails'
require 'json_matchers/rspec'
require 'pundit/rspec'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = Rails.root.join('spec', 'fabricators')

  # Set `true` for using in System test
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.include ControllerMacros, type: :controller
  config.include Rails.application.routes.url_helpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component

end
