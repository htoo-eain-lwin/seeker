# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/jobs'
  use_doorkeeper

  get 'dashboard', to: 'dashboard#index'
  resources :search, only: %i[new show create] do
    post :upload, on: :collection
  end
  resources :keywords, only: %i[index show] do
    get :result, on: :member
  end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  draw :api
end
