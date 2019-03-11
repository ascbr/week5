Rails.application.routes.draw do
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
