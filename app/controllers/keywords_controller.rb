# frozen_string_literal: true

class KeywordsController < ApplicationController
  def create
    @keyword = Keyword.new(keyword_params)
    redirect_to result_keyword_path(@keyword.name) if @keyword.save
  end

  def result
    @keyword = Keyword.find_by name: params[:id]
    CreateResultService.call(@keyword)
  end

  private

  def keyword_params
    params.require(:keyword).permit(:name)
  end
end
