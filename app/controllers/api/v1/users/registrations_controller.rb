# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < ApiController
        skip_before_action :doorkeeper_authorize!, only: %i[create]

        include DoorkeeperRegisterable

        def create
          client_app = Doorkeeper::Application.find_by(uid: user_params[:client_id])
          return unauthorized_error unless client_app

          allowed_params = user_params.except(:client_id)
          user = User.new(allowed_params)
          if user.save
            render json: render_user(user, client_app), status: :ok
          else
            render json: { errors: error_message(user) }, status: :unprocessable_entity
          end
        end

        private

        def error_message(user)
          errors = user.errors.messages.dup
          errors.each_key { |i| errors[i] = errors[i].join(', ') }
        end

        def unauthorized_error
          render json: { error: I18n.t('doorkeeper.errors.messages.invalid_client') }, status: :unauthorized
        end

        def user_params
          params.permit(:email, :password, :client_id)
        end
      end
    end
  end
end
