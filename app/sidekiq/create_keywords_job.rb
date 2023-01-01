# frozen_string_literal: true

class CreateKeywordsJob
  include Sidekiq::Job
  sidekiq_options queue: 'default'

  def perform(search_id)
    search = Search.find_by id: search_id
    return unless search

    keywords = ApplicationController.helpers.list_keywords(search.csv_file)
    keywords.each do |keyword|
      Keyword.find_or_create_by(name: keyword)
    end
  end
end
