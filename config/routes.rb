Rails.application.routes.draw do
  root 'home#index'

  resources :games, only: [:show, :index] do
    get :replay, on: :member, as: :replay_of
  end

  resources :categories, only: [:show], param: :name do
    resources :players, only: [:show], param: :name, :constraints => { :name => /[^\/]+/ }
  end

  get '/players/:name', to: 'players#show_1v1', :constraints => { :name => /[^\/]+/ }
  get '/changelog', to: 'home#changelog', as: 'changelog'
end
