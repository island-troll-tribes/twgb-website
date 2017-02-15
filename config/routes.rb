Rails.application.routes.draw do
  root 'home#index'

  get '/players/:name', to: 'players#show', :constraints => { :name => /[^\/]+/ }
  get '/changelog', to: 'home#changelog'

  resources :w3mmd_elo_scores
  resources :games
end
