Rails.application.routes.draw do
  devise_for :users, skip: [:passwords]
  get 'pages/about'
  root "pages#homepage"
  resources :ideas do
    resources :comments
    member do
      patch :toggle_submission
    end
  end
  # root "hello#index"
end
