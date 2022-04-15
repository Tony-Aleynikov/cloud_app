Rails.application.routes.draw do
  mount GrapeApi => '/api'
  mount GrapeSwaggerRails::Engine => '/swagger'

  root 'orders#calc'

  namespace :admin do
    root 'welcome#index'
  end

  resources :groups
  get 'hello/index'
  # get 'orders/check', to: 'orders#check'
  get 'orders/status', to: 'orders#status'

  resource :login, only: [:show, :create, :destroy]#
  resources :users
  resources :vms
  resources :orders do
    get 'approve', on: :member
    get 'first', on: :collection
  end
end
