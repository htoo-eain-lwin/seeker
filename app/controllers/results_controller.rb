# frozen_string_literal: true

class ResultsController < ApplicationController
  include Pagy::Backend
  def index
    @search = current_user.keywords.ransack(params[:search])
    @pagy, @keywords = pagy(@search.result(distinct: true)
                                   .order('created_at desc')
                                   .includes(:result), items: 20)
  end
end
