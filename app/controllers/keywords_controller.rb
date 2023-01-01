# frozen_string_literal: true

class KeywordsController < ApplicationController
  before_action :authenticate_user!

  def create
    @keyword = Keyword.find_or_create_by(name: keyword_params[:name])
    if @keyword.save
      redirect_to result_keyword_path(@keyword.name)
    else
      redirect_back_or_to dashboard_path
    end
  end

  def result
    keyword = Keyword.find_by name: params[:id]
    CreateResultService.call(keyword)
    @result = Result.find_by keyword_id: keyword
  end

  private

  def keyword_params
    params.require(:keyword).permit(:name)
  end
end
