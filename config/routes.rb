Rails.application.routes.draw do

  resources :borrower_uploader, only: [] do
    member do
      post 'bank_statement'
      post 'paystub'
      post 'w2'
      delete 'remove_bank_statement'
      delete 'remove_paystub'
      delete 'remove_w2'
      get 'download_w2'
      get 'download_paystub'
      get 'download_bank_statement'
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users

  resources :loans do
    member do
    end
  end

  resources :rates

  resources :properties do
    collection do
      get :search
    end
  end

  root 'pages#index'
  get 'take_home_test'    => 'pages#take_home_test',    as: :take_home_test
end
