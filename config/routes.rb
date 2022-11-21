Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/signup' ,to: 'users#new'
  get 'static_pages/about'
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/contact'
  resources :users do
    member do 
      get :following, :followers
    end
  end
  resources :account_activations , only: [:edit]
  resources :password_resets  ,    only: [:new , :create, :edit, :update]
  resources :posts ,               only: [:destroy, :create]
  resources :relationships,        only: [:create, :destroy]
  root "static_pages#home"
end
