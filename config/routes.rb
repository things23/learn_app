Rails.application.routes.draw do
  root "static_pages#home"
  resources :user_sessions
  resources :decks do
    resources :cards, shallow: true
  end
  resources :users do
    put "pick_deck", on: :member
  end
  put "review_card", to: "static_pages#review_card"
  get "landing", to: "static_pages#landing"

  get "login" => "user_sessions#new", :as => :login
  post "logout" => "user_sessions#destroy", :as => :logout

  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback" # for use with Github
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
end
