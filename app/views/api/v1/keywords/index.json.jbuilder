# frozen_string_literal: true

json.data do
  json.partial! partial: 'api/v1/keywords/keyword', collection: @keywords, as: :keyword
end
json.meta do
  json.has_next_page @pagy.page * @pagy.items < @keywords.count
end
