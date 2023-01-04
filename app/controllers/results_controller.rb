# frozen_string_literal: true

class ResultsController < ApplicationController
  include Pagy::Backend
  def index
    @q = current_user.keywords.ransack(params[:q])
    @pagy, @keywords = pagy(@q.result
                              .joins(:result)
                              .order('keywords.created_at desc')
                              .includes(:result), items: 20)
  end

  def new
    @search = Search.find_by(id: params[:search_id])
    @keywords = @search.keywords
  end

  def import
    @search = Search.find_by(id: params[:search_id])
    @keywords = @search.keywords
    CreateKeywordsAndResultsService.call(@search.id)
    render turbo_stream: turbo_stream.replace("search_#{@search.id}", partial: 'results/go_to_link')
  end
end
