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

  resources :products do
    collection do
      post 'search'
    end
  end

  resources :orders do
    collection do
      post 'purchase'
      get 'purchase_log'
    end
  end
  
  devise_for :users
  root 'products#index'
end
