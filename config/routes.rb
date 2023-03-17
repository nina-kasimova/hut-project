Rails.application.routes.draw do
  resources :questions do
    resources :answers, shallow: true
  end

  root 'questions#index'
  devise_for :users
  resources :electives
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  get "/search", to: "search#search"
  get "/search_electives", to: "search#show"
end
