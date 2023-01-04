# frozen_string_literal: true

json.success true
json.data do
  json.partial! partial: 'api/v1/search/search'
end
