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
  resources :work_logs
  get 'profile', to: 'profiles#show', as: :profile
  get 'profile/edit', to: 'profiles#edit', as: :edit_profile
  patch 'profile', to: 'profiles#update'
  # root "hello#index"
end
