Rails.application.routes.draw do


  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tweets, only: [:index, :create, :show, :destroy] do
    post '/reply', to: 'tweets/replies#create'
    post '/retweet', to: 'tweets/retweets#create'
    delete '/retweet', to: 'tweets/retweets#destroy'
  end
  resources :users, only: [:show]
  
  root to: 'tweets#index'
end
