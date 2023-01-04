# frozen_string_literal: true

module Api
  module V1
    class KeywordsController < ApiController
      def index
        @pagy, @keywords = pagy(current_user.keywords
                                            .includes(:users)
                                            .includes(:searches))
      end
    end
  end
end
