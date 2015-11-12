require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  root to: "main#index"

  resources :phoenixes, except: [:show]

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
end
