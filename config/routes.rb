Rails.application.routes.draw do
  resources :products
  resources :orders do
    collection do
      post 'purchase'
    end
  end
  devise_for :users
   root 'products#index'
end
