Rails.application.routes.draw do
  post 'home/create_tweet'
  devise_for :users
  root 'home#index'

  resources :users do
    member do
      post :follow
      delete :unfollow
    end

    collection do
      get :peoples
    end
  end

  namespace :api do
    namespace :v1 do
      resources :sessions, only: [:create]
      resources :tweets, only: [:create, :index]
      resources :users, only: [:index]
    end
  end
end
