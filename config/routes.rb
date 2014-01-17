Autotest::Application.routes.draw do

  resources :scenarios

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

  # Test Pages
  get '/test/index', to: "autotest#index"
  get '/test/form', to: "autotest#form", as: "test_form"
  post '/test/form_post', to: "autotest#form_post", as: "test_form_post"
  get '/test/thankyou', to: "autotest#thankyou", as: "test_thankyou"

  namespace :api do
    namespace :v1 do
      resources :projects do
        resources :features do
          resources :scenarios do
            resources :steps
          end
        end
      end
    end
  end

end
