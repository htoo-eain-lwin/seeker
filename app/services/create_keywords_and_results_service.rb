# frozen_string_literal: true

class CreateKeywordsAndResultsService < ApplicationService
  def initialize(search_id)
    @search = Search.find_by id: search_id
    @keywords = CsvService.call(@search)
    super
  end

  def call
    return if @keywords.empty?

    create_keywords
  end

  def create_keywords
    @keywords.each_slice(10) do |keys|
      saved_keywords = []
      keys.each { |key| saved_keywords << CreateKeywordService.call(key, @search.id) }
      CreateResultsJob.perform_async(saved_keywords.pluck(:id))
    end
  end
end
