Autotest::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :admin do
    resources :beta_invitations, only: [:index] do
      member do
        post 'invite'
      end
    end
  end

  get "/recorder" => "recorder#index"
  get "/developer" => "recorder#developer"


  namespace :heroku do
    resources :resources
    post '/sso/login' => "sso#create"
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  mount MailPreview => 'mail_view' if Rails.env.development?

  resources :scenarios
  resources :plans do
    member do
      get :upgrade
      post :upgrade
      post :downgrade
    end
  end
  resources :credit_cards, only: [:index, :create, :destroy], path: "credit-cards" do
    member do
      post :default
    end
  end
  resources :messages do
    member do
      post :mark_read
    end
    collection do
      post :mark_all_read
    end
  end

  post "/send-developer-emails" => "pages#send_developer_emails", as: "send_developer_emails"

  get "/tours" => "tours#show"
  put "/tours" => "tours#update"

  #application
  devise_for :users, controllers: {registrations: :registrations, sessions: :sessions, omniauth_callbacks: :omniauth_callbacks, passwords: :passwords}, skip: :invitations
  devise_scope :user do
    get "/login" => "sessions#new"
    get "/logout" => "sessions#destroy"
    get '/sign-up-free' => 'registrations#new', as: 'sign_up_free'
    get '/my-info' => 'registrations#edit', as: 'my_info'
    get '/change-your-plan' => 'registrations#change_plan', as: 'change_plan'
    post "/upgrade/:plan_id" => 'registrations#upgrade', as: 'upgrade'
    get '/upgrade/:plan_id' => "registrations#upgrade", as: "get_upgrade"
    get '/downgrade/:plan_id' => "registrations#downgrade", as: "get_downgrade"
    get '/manage-billing' => 'registrations#manage_billing', as: 'billing'
    get '/users/confirm' => "confirmations#show", as: 'confirmation'
    post '/cancel' => "registrations#cancel_user", as: "cancel"
  end

  get 'dashboard', to: "dashboard#index"

  as :user do
    get 'invitations', to: 'invitations#index', as: 'invitations'
    get 'invitation', to: "invitations#new", as: :new_invitation
    post 'invitation', to: "invitations#create"
    get 'invitation/accept', to: "invitations#edit", as: :accept_invitation
    put 'invitation/accept', to: "invitations#update", as: :complete_invitation
  end

  resources :projects do
    post 'remove_user/:user_id', to: 'projects#remove_user', on: :member, as: :remove_user
    post 'verify_script', to: 'projects#verify_script', as: :verify_script
    post 'update_notifications', to: "projects#update_notifications", on: :member, as: :update_notifications
    put 'add_owner/:user_id', to: 'projects#add_owner', as: :add_owner
    put 'remove_owner/:user_id', to: 'projects#remove_owner', as: :remove_owner
    post :run, on: :member
    resources :test_runs, controller: :project_test_runs, only: [:index, :show]
    resources :tests, controller: :scenarios do
      post :run, on: :member, as: "run_scenario"
      resources :steps
      resources :test_runs, only: [:index, :show]
    end
  end

  namespace :api do
    namespace :v1 do
      match '/scenarios' => "scenarios#create", via: :options
      match '/scenarios/:scenario_id' => "scenarios#show", via: :options
      match '/scenarios/:scenario_id/steps' => "steps#create", via: :options
      match '/scenarios/:scenario_id/publish' => "scenarios#publish", via: :options
      match '/scenarios/:scenario_id/publish' => "scenarios#publish", via: :post
      resources :scenarios do
        resources :steps
      end
    end

    namespace :dashing do
      match '/total_tests_run' => "dashboard#total_tests_run", via: :get
      match '/total_minutes' => "dashboard#total_minutes", via: :get
    end
  end

  #pages
  get 'faqs', to: 'pages#faqs'
  get 'pricing', to: 'pages#pricing'
  get 'documentation', to: 'pages#documentation'
  # get 'privacy', to: 'pages#privacy'
  get 'terms', to: 'pages#terms'
  get 'beta-invitation', to: 'pages#beta_invitation', as: 'beta_invitation'
  post 'create-beta-invitation', to: 'pages#create_beta_invitation', as: 'create_beta_invitation'
  post '/coupons/redeem', to: "coupons#redeem", as: "redeem_coupon"

  # Test Pages
  get '/test/index', to: "autotest#index"
  get '/test/form', to: "autotest#form", as: "test_form"
  post '/test/form_post', to: "autotest#form_post", as: "test_form_post"
  get '/test/thankyou', to: "autotest#thankyou", as: "test_thankyou"
  get '/test/terms', to: "autotest#terms", as: 'test_terms'

  root 'pages#welcome'
end
