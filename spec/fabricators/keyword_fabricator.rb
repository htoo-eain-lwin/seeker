# frozen_string_literal: true

Fabricator(:keyword) do
  name { FFaker::Name.name }
  user
end
