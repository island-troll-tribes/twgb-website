Rails.application.routes.draw do
  root 'home#index'

  resources :w3mmd_elo_scores
  resources :games
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
