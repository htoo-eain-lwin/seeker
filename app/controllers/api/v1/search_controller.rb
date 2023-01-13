# frozen_string_literal: true

module Api
  module V1
    class SearchController < ApiController
      before_action :check_file, only: [:upload]

      def upload
        keywords = CsvService.call(File.read(file))
        return too_many_keywords if keywords.count > 100

        search = Search.new(user_id: params[:user_id])
        search.save
        CreateKeywordsAndResultsService.call(search.id, keywords)
        render json: { success: true, search: search, message: 'Keywords are starting to import.' }, status: :created
      end

      def show
        @search = Search.find_by(id: params[:id], user_id: current_user)
        if @search
          @pagy, @keywords = pagy(@search.keywords
                                         .includes(:result))
          render 'show'
        else
          render json: { success: false,
                         error: 'The search you are looking for does not exist. Plese try Search again' }
        end
      end

      private

      def too_many_keywords
        render json: { success: false, error: 'more than 100 keywords' }, status: :unprocessable_entity
      end

      def valid_file?
        file.content_type == 'text/csv' || file.content_type == 'csv'
      end

      def file
        search_params[:file]
      end

      def check_file
        return invalid_file unless file.present? && valid_file?
      end

      def invalid_file
        render json: { success: false, error: 'No file presented' }, status: :unprocessable_entity
      end

      def search_params
        params.require(:search).permit :file, :content_type
      end
    end
  end
end
