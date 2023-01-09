# frozen_string_literal: true

class KeywordsController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!

  def index
    @q = current_user.keywords.ransack(params[:q])
    @pagy, @keywords = pagy(@q.result
                              .joins(:result)
                              .order('keywords.created_at desc')
                              .includes(:result), items: 20)
  end

  def result
    keyword = Keyword.find_by id: params[:id]
    @result = keyword.result
  end

  private

  def keyword_params
    params.require(:keyword).permit(:name)
  end
end
