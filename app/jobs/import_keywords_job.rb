# frozen_string_literal: true

class ImportKeywordsJob
  include Sidekiq::Job
  sidekiq_options queue: 'default'

  def perform(id)
    search = Search.find_by id: id
    return unless search

    CreateKeywordsAndResultsService.call(id)
  end
end
