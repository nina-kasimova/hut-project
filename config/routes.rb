Rails.application.routes.draw do
  devise_for :users
  resources :electives
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"

  get "/search", to: "search#index"
  get "/search_electives", to: "search#show"
end
