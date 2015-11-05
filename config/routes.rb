Rails.application.routes.draw do
  root to: "main#index"

  resources :phoenixes, except: [:show]
end
