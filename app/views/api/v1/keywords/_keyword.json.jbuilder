# frozen_string_literal: true

keyword ||= @keyword
result = keyword.result
json.cache! [keyword, keyword.users, keyword.result] do
  json.id keyword.id
  json.name keyword.name
  json.created_at keyword.created_at
  json.upated_at keyword.updated_at
  json.has_result keyword.result.present?
  if result
    json.result do
      json.id result.id
      json.stats result.stats
      json.total_urls result.total_urls
      json.total_advertisers result.total_advertisers
      json.html_file Rails.application.routes.url_helpers.rails_blob_url(result.html_file, only_path: true)
    end
  end
end
