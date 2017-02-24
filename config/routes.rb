Rails.application.routes.draw do
  root 'home#index'

  resources :categories, only: [:show], param: :name do
    resources :games, only: [:show]
    resources :players, only: [:show], param: :name, :constraints => { :name => /[^\/]+/ }
  end

  get '/players/:name', to: 'players#show_1v1', :constraints => { :name => /[^\/]+/ }
  get '/changelog', to: 'home#changelog', as: 'changelog'

  resources :w3mmd_elo_scores
  resources :games
end
