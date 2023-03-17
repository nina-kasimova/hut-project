Rails.application.routes.draw do
  resources :questions do
    resources :answers, shallow: true
  end

  devise_for :users
  resources :electives do
    resources :questions
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"

  get "/search", to: "search#search"
  get "/search_electives", to: "search#show"
  get "/questions", to: "questions#index"
end
