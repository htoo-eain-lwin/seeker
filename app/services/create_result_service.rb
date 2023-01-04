# frozen_string_literal: true

class CreateResultService < ApplicationService
  def initialize(result_params)
    @params = result_params
    @keyword = Keyword.find_by(id: @params[:keyword_id])
    @result = @keyword.result
    super
  end

  def call
    return unless @keyword

    @result.present? ? update_result : new_result
    @result.html_file.attach(io: file(@params[:html_file]), filename: file_name)
    @result.save
  end

  def update_result
    @result.update(build_params)
  end

  def new_result
    @result = Result.new(build_params)
  end

  def build_params
    {
      keyword_id: @keyword.id,
      stats: @params[:stats],
      total_urls: @params[:total_urls],
      total_advertisers: @params[:total_advertisers]
    }
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
