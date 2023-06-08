# frozen_string_literal: true

class CsvService < ApplicationService
  def initialize(content)
    @content = content
    super
  end

  def call
    @content.gsub(', ', ',').tr("\n", ',').split(',')
  end
end
