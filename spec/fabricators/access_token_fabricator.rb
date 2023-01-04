# frozen_string_literal: true

Fabricator(:access_token, from: 'Doorkeeper::AccessToken') do
  application
  expires_in { 2.hours }
  scopes { 'read' }
end
