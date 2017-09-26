Rails.application.routes.draw do
  root 'home#index'

  resources :games, only: [:show, :index] do
    get :replay, on: :member, as: :replay_of
  end

  resources :players, only: [:show, :index], param: :name, constraints: { name: /((?:.(?!\.json$))*(?:$|.))/ }
  resources :standings, only: [:show, :index], param: :name
  resources :classes, only: [:show, :index], param: :class

  resources :maps, only: [], param: :version, constraints: { version: /((?:.(?!\.json$))*(?:$|.))/ } do
    get :download, on: :member, as: :map_download
  end

  get '/games_list', to: 'game_list#index', as: 'game_list'
  get '/meta', to: 'home#meta', as: 'meta'
  get '/compare', to: 'players#compare', as: 'compare_players'
  get '/changelog', to: 'home#changelog', as: 'changelog'
  get '/competitions', to: 'home#competitions', as: 'competitions'
  get '/player_activity', to: 'home#player_last_played', as: 'player_last_played'
end
