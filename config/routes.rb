Rails.application.routes.draw do
  devise_for :users
  resources :electives
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"

  get "/search", to: "search#search"
  get "/search_electives", to: "search#show"
  get "/wp_support", to: "pages#wp_support"
  get "/finances", to: "pages#finances"
  get "/faq", to: "pages#faq"

end
