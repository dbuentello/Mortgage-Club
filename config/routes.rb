Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users

  resources :loans do
    resource :property,           :controller => :loan_property
    resource :borrower,           :controller => :loan_borrower
    resource :secondary_borrower, :controller => :loan_borrower, defaults: { type: 'is_secondary' }
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
