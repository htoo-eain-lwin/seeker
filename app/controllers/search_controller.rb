# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :authenticate_user!

  def new
    @search = Search.new
  end

  def upload
    return redirect_to new_search_path, error: 'invalid file' unless valid_file?

    @keywords = CsvService.call(File.read(file))
    return redirect_to new_search_path, error: 'more than 100 keywords' if too_many_keywords?

    @search = Search.new
    render turbo_stream: turbo_stream.replace('keywords', partial: 'temp_keywords', locals: { keywords: @keywords })
  end

  def create
    @search = Search.new(user_id: current_user.id)
    if @search.save
      CreateKeywordsAndResultsService.call(@search.id, keywords)
      redirect_to search_path(@search.id)
    else
      render 'new'
    end
  end

  def show
    @search = Search.find_by(id: params[:id])
    @keywords = @search.keywords.includes(:result)
  end

  private

  def keywords
    search_params[:keywords].split(',')
  end

  def too_many_keywords?
    @keywords.length > 100
  end

  def valid_file?
    file.content_type == 'text/csv' || file.content_type == 'csv'
  end

  def file
    search_params[:csv_file]
  end

  def search_params
    params.require(:search).permit(:csv_file, :keywords)
  end
end
