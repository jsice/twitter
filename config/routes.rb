Rails.application.routes.draw do


  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tweets, only: [:index, :create, :show, :destroy] do
    post '/reply', to: 'tweets/replies#create'
    post '/retweet', to: 'tweets/retweets#create'
    delete '/retweet', to: 'tweets/retweets#destroy'
    post '/like', to: 'tweets/likes#create'
    delete '/like', to: 'tweets/likes#destroy'
  end

  resources :users, only: [:show] do
    post '/follow', to: 'users/followers#create'
    delete '/follow', to: 'users/followers#destroy' 
  end
  
  get 'hashtags/:hashtag', to: 'hashtags#show', as: :hashtag
  
  root to: 'tweets#index'
end
