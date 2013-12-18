Autotest::Application.routes.draw do

  #application
  devise_for :users, controllers: {registrations: :registrations}

  get 'dashboard', to: "dashboard#index.html.haml"

  resources :projects do
    resources :features do
      resources :scenarios do
        resources :steps
      end
    end
  end

  #pages
  get 'privacy', to: 'pages#privacy'
  get 'terms', to: 'pages#terms'

  #welcome pages
  get '/tour', to: 'welcome#tour'
  get 'pricing', to: 'welcome#pricing'
  root 'welcome#index.html.haml'

end
