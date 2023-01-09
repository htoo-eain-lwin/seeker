# frozen_string_literal: true

class CreateKeywordService < ApplicationService
  def initialize(name, search_id)
    @name = name
    @search = Search.find_by id: search_id
    @keyword = Keyword.find_by(name: name, user_id: @search&.user_id)
    super
  end

  def call
    return unless @search

    @keyword ||= Keyword.create(name: @name, user_id: @search.user_id)
    @search.keywords << @keyword
    @search.user.keywords << @keyword
    @keyword
  end
end
