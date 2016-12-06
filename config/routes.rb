Rails.application.routes.draw do
  root 'home#index'

  get '/players/:name', to: 'players#show', :constraints => { :name => /[^\/]+/ }

  resources :w3mmd_elo_scores
  resources :games
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
