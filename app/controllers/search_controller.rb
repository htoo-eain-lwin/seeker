# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :authenticate_user!

  def new
    @search = Search.new
  end

  def upload
    @search = Search.new(search_params.merge!(user: current_user))
    if @search.valid? && @search.save
      CreateKeywordsJob.perform_async(@search.id)
      redirect_to search_path(@search.id)
    else
      render 'new'
    end
  end

  def show
    @search = Search.find_by(id: params[:id])
    @keyword = Keyword.new
  end

  private

  def search_params
    params.require(:search).permit(:csv_file)
  end
end
