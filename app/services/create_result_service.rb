# frozen_string_literal: true

class CreateResultService < ApplicationService
  def initialize(keyword)
    @keyword = keyword
    super
  end

  def call
    return true if result_exists?

    results = KeywordToResultsService.call(@keyword.name)
    create_result(results)
  end

  def create_result(results)
    res = Result.new(
      keyword_id: @keyword.id,
      stats: results[:stats],
      total_urls: results[:total_urls],
      total_advertisers: results[:total_advertisers]
    )
    res.html_file.attach(io: file(results[:html]), filename: file_name)
    res.save
  end

  def file(html_body)
    io = StringIO.new
    io.puts(html_body)
    io.rewind
    io
  end

  def file_name
    "#{SecureRandom.uuid}.html"
  end

  def result_exists?
    @keyword.result.present?
  end
end
