Autotest::Application.routes.draw do

  resources :scenarios

  resources :features

  resources :projects

  resources :companies

  devise_for :users

  #pages
  get 'privacy', to: 'pages#privacy'
  get 'terms', to: 'pages#terms'

  #welcome pages
  get '/tour', to: 'welcome#tour'
  get 'pricing', to: 'welcome#pricing'
  root 'welcome#index'

end
