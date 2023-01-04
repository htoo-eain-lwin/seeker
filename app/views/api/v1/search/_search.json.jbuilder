# frozen_string_literal: true

search ||= @search
total_keywords = @search.keywords_from_file
saved_keywords = @keywords
fail_to_save_keywords_count = total_keywords.count - saved_keywords.count

json.cache! [search, search.user] do
  json.id search.id
  json.created_at search.created_at
  json.upated_at search.updated_at
  json.total_keywords_from_file total_keywords.count
  json.total_saved_keywords @keywords.count
  json.fail_to_save_keywords fail_to_save_keywords_count
  json.keywords do
    json.data do
      json.partial! partial: 'api/v1/keywords/keyword', collection: @keywords, as: :keyword
    end
    json.meta do
      json.has_next_page @pagy.page * @pagy.items < @keywords.count
    end
  end
end
