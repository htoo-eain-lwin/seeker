# frozen_string_literal: true

namespace :api do
  namespace :v1 do
    get 'keywords', to: '/api/v1/keywords#index'
    post 'search/upload', to: '/api/v1/search#upload'
    get 'search/:id', to: '/api/v1/search#show'
    scope :users, module: :users do
      post '/', to: 'registrations#create', as: :user_registration
    end
  end
end

# Doorkeeper integration
scope :api do
  scope :v1 do
    use_doorkeeper do
      skip_controllers :authorizations, :applications, :authorized_applications
    end
  end
end
