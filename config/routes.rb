Autotest::Application.routes.draw do

  resources :beta_invitations

  root 'welcome#index'

end
