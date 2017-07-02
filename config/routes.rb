Rails.application.routes.draw do
  root 'home#index'

  resources :games, only: [:show, :index] do
    get :replay, on: :member, as: :replay_of
  end

  resources :players, only: [:show, :index], param: :name, constraints: { name: /((?:.(?!\.json$))*(?:$|.))/ }
  resources :standings, only: [:show, :index], param: :name

  get '/games_list', to: 'game_list#index', as: 'game_list'
  get '/changelog', to: 'home#changelog', as: 'changelog'
  get '/competitions', to: 'home#competitions', as: 'competitions'
end
