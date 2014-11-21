Rails.application.routes.draw do
  root "static_pages#home"
  resources :cards
  resources :user_sessions
  resources :users
  put "review_card", to: "static_pages#review_card"

  get "login" => "user_sessions#new", :as => :login
  post "logout" => "user_sessions#destroy", :as => :logout

  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback" # for use with Github
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

end
