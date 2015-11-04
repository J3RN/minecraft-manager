Rails.application.routes.draw do
  root to: "main#index"
  post '/', to: "main#update"
end
