Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/signup' ,to: 'users#new'
  get 'static_pages/about'
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/contact'
  resources :microposts
  resources :users
  resources :posts , only: [:destory, :create]
  root "static_pages#home"
end
