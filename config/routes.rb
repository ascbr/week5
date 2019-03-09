Rails.application.routes.draw do
  resources :products do
    collection do
      post 'search' 
    end
  end

  resources :orders do
    collection do
      post 'purchase'
    end
  end
  devise_for :users
   root 'products#index'
end
