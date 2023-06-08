# frozen_string_literal: true

class CreateResultsJob
  include Sidekiq::Job
  sidekiq_options queue: 'default'

  URL = 'https://www.google.com/search'

  def perform(keywords, url: nil)
    url ||= URL
    crawler = SearchCrawler.new(keywords, url)
    crawler.results.each do |result|
      CreateResultService.call(result)
    end
  end
end
