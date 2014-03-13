Autotest::Application.routes.draw do
  namespace :admin do
    resources :beta_invitations, only: [:index] do
      member do
        post 'invite'
      end
    end
  end

  get "/recorder" => "recorder#index"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end

  resources :scenarios

  #application
  devise_for :users, controllers: {registrations: :registrations, sessions: :sessions, omniauth_callbacks: :omniauth_callbacks}, skip: :invitations
  devise_scope :user do
    get "/login" => "sessions#new"
    get '/get-started' => 'registrations#new', as: 'get_started'
    post "/upgrade/:plan_id" => 'registrations#upgrade', as: 'upgrade'
    get '/upgrade/:plan_id' => "registrations#upgrade", as: "get_upgrade"
    get '/downgrade/:plan_id' => "registrations#downgrade", as: "get_downgrade"
    post '/cancel' => "registrations#cancel_user", as: "cancel"
  end

  # get 'dashboard', to: "dashboard#index.html.haml"

  as :user do
    get 'invitation', to: "invitations#new", as: :new_invitation
    post 'invitation', to: "invitations#create"
    get 'invitation/accept', to: "invitations#edit", as: :accept_invitation
    put 'invitation/accept', to: "invitations#update", as: :complete_invitation
  end

  resources :projects do
    post 'remove_user/:user_id', to: 'projects#remove_user', on: :member, as: :remove_user
    get 'verify_script', to: 'projects#verify_script', as: :verify_script, via: :get
    post 'update_notifications', to: "projects#update_notifications", on: :member, as: :update_notifications
    post :run, on: :member
    resources :test_runs, controller: :project_test_runs, only: [:index, :show]
    resources :features do
      post :run, on: :member
      resources :test_runs, controller: :feature_test_runs, only: [:index, :show]
      resources :scenarios do
        post :run, on: :member, as: "run_scenario"
        resources :steps
        resources :test_runs, only: [:index, :show]
      end
    end
  end

  #pages
  get 'privacy', to: 'pages#privacy'
  get 'terms', to: 'pages#terms'

  #welcome pages
  get '/tour', to: 'welcome#tour'
  get 'pricing', to: 'welcome#pricing'
  #root 'welcome#index.html.haml'

  # Test Pages
  get '/test/index', to: "autotest#index"
  get '/test/form', to: "autotest#form", as: "test_form"
  post '/test/form_post', to: "autotest#form_post", as: "test_form_post"
  get '/test/thankyou', to: "autotest#thankyou", as: "test_thankyou"

  namespace :api do
    namespace :v1 do
      match '/features' => "features#index", via: :options
      match '/features/:feature_id' => "features#show", via: :options
      match '/features' => "features#create", via: :options
      match '/features/:features_id/scenarios' => "scenarios#create", via: :options
      match '/features/:feature_id/scenarios/:scenario_id' => "scenarios#show", via: :options
      match '/features/:features_id/scenarios/:scenario_id/steps' => "steps#create", via: :options
      resources :features do
        resources :scenarios do
          resources :steps
        end
      end
    end
  end
  resources :beta_invitations
  post '/coupons/redeem', to: "coupons#redeem", as: "redeem_coupon"

  root 'welcome#index'

end
