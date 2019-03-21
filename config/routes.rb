Rails.application.routes.draw do
  
  get 'comments/index'
  get 'comments/new'
  #REST API
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :products
      resources :sessions
    end
  end

  #MVC 
  resources :likes

  resources :products do
    resources :comments
  end

  

  resources :orders

  resources :purchases do
    collection do
      get 'purchase_log'
    end
  end
  devise_for :users
  resources :users do
    resources :comments
  end

  root 'products#index'
end
