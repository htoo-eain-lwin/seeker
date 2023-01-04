# frozen_string_literal: true

Fabricator(:application, from: 'Doorkeeper::Application') do
  name { FFaker.name }
end
