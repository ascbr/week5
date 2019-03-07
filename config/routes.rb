Rails.application.routes.draw do
  resources :products do
    post "show"
  end
  devise_for :users
  root 'products#index'
end
