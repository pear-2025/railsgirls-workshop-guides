Rails.application.routes.draw do
  get 'pages/about'
  root "pages#homepage"
  resources :ideas do
    resources :comments
  end
  # root "hello#index"
end
