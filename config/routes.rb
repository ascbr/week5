Rails.application.routes.draw do
  
  #REST API
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :products
      resources :sessions
    end
  end

  #MVC 
  resources :likes

  resources :products

  resources :orders

  resources :purchases do
    collection do
      get 'purchase_log'
    end
  end
  devise_for :users
  root 'products#index'
end
