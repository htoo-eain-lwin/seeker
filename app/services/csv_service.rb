# frozen_string_literal: true

class CsvService < ApplicationService
  def initialize(search)
    @search = search
    super
  end

  def call
    csv = @search.csv_file.download
    csv.gsub(', ', ',').tr("\n", ',').split(',')
  end
end
