# frozen_string_literal: true

module Api
  module V1
    class SearchController < ApiController
      def upload
        search = BuildSearchService.call(search_params.merge!(user_id: current_user.id))
        if search.present?
          ImportKeywordsJob.perform_async(search.id)
          render json: { success: true, search: search,
                         message: 'Keywords are starting to import.' }, status: :created
        else
          render json: { success: false, error: 'Something went wrong while uploading file' },
                 status: :unprocessable_entity
        end
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

      def search_params
        params.require(:search).permit :file, :content_type
      end
    end
  end
end
