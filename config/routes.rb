Rails.application.routes.draw do
  get 'proxy', to: 'proxy#index'
  get 'keywords/create'
  get 'keyword/create'
  get 'dashboard', to: 'dashboard#index'
  resources :search, only: %i[new show] do
    post :upload, on: :collection
  end
  resources :keywords, only: %i[show create] do
    get :result, on: :member
  end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
