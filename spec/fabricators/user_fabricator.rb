# frozen_string_literal: true

Fabricator(:user) do
  email { FFaker::Internet.email }
end
