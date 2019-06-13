Rails.application.routes.draw do


  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tweets, only: [:index, :create, :show, :delete] do
    post '/reply', to: 'tweets/replies#create'
  end
  resources :users, only: [:show]
  
  root to: 'tweets#index'
end
