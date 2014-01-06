Autotest::Application.routes.draw do

  #application
  devise_for :users, controllers: {registrations: :registrations}, skip: :invitations

  get 'dashboard', to: "dashboard#index.html.haml"

  as :user do
    get 'invitation', to: "invitations#new", as: :new_invitation
    post 'invitation', to: "invitations#create"
    get 'invitation/accept', to: "invitations#edit", as: :accept_invitation
    put 'invitation/accept', to: "invitations#update", as: :complete_invitation
  end

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
