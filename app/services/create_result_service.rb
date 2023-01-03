# frozen_string_literal: true

class CreateResultService < ApplicationService
  def initialize(result_params)
    @params = result_params
    super
  end

  def call
    result = Result.new(
      keyword_id: @params[:keyword_id],
      stats: @params[:stats],
      total_urls: @params[:urls],
      total_advertisers: @params[:total_advertisers]
    )
    result.html_file.attach(io: file(@params[:html_file]), filename: file_name)
    result.save
  end

  def file_name
    "#{SecureRandom.uuid}.html"
  end

  def file(html_body)
    io = StringIO.new
    io.puts(html_body)
    io.rewind
    io
  end
end
