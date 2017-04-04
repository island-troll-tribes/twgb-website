Rails.application.routes.draw do
  root 'home#index'

  resources :games, only: [:show, :index] do
    get :replay, on: :member, as: :replay_of
  end

  resources :players, only: [:show], param: :name, constraints: { name: /((?:.(?!\.json$))*(?:$|.))/ } do
    resources :categories, only: [:show], param: :name
  end

  resources :standings, only: [:show, :index], param: :name

  get '/changelog', to: 'home#changelog', as: 'changelog'
end
