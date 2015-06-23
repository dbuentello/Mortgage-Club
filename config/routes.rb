Rails.application.routes.draw do

  resources :borrower_uploader, only: [] do
    member do
      post 'bank_statements'
      post 'paystubs'
      post 'w2s'
      delete 'remove_bank_statements'
      delete 'remove_paystubs'
      delete 'remove_w2s'
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
