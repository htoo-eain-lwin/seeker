# frozen_string_literal: true

class KeywordsController < ApplicationController
  before_action :authenticate_user!

  def result
    keyword = Keyword.find_by id: params[:id]
    @result = keyword.result
  end

  private

  def keyword_params
    params.require(:keyword).permit(:name)
  end
end
