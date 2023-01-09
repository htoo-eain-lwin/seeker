# frozen_string_literal: true

class CreateKeywordService < ApplicationService
  def initialize(name, search_id)
    @name = name
    @keyword = Keyword.find_by(name: name, search_id: search_id)
    @search = Search.find_by id: search_id
    super
  end

  def call
    return unless @search

    @keyword ||= Keyword.create(name: @name, search_id: @search.id)
    @search.user.keywords << @keyword
    @keyword
  end
end
