Rails.application.routes.draw do
  get 'dashboard', to: 'dashboard#index'
  get 'search/new'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
