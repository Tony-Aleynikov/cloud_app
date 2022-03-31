Rails.application.routes.draw do
  namespace :admin do
    root 'welcome#index'
  end
  root 'orders#calc'
  #get 'orders/calc'
  #get 'calc', to: 'orders#calc'
    get 'hello/index'
  

  resources :orders do
    member do
      get 'approve'
    end
    get 'first', on: :collection
  end

  resources :users
  #resources :orders строка 8 (если там есть ордерс, то эта строка не нужна?)

  resource :login, only: [:show, :create, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
