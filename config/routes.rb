Rails.application.routes.draw do

  root 'pages#index'

  get 'take_home_test', to: 'pages#take_home_test', as: :take_home_test

  devise_for :users,
    controllers: {
      sessions: 'users/sessions', registrations: 'users/registrations',
      confirmations: 'users/confirmations', passwords: 'users/passwords',
      unlocks: 'users/unlocks'
    },
    path: 'auth',
    path_names: {
      sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification',
      unlock: 'unblock', registration: 'register', sign_up: 'signup'
    }

  devise_scope :user do
    get 'login', to: 'users/sessions#new', as: :custom_login
    get 'signup', to: 'users/registrations#new', as: :custom_signup
  end

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

  resources :property_document_uploader do
    collection do
      post 'upload'
      delete 'remove'
    end

    member do
      get 'download'
    end
  end

  resources :loan_document_uploader do
    member do
      get 'download'
    end
  end

  resources :document_uploader do
    member do
      get 'download'
    end
  end

  # resource :dashboard, only: [:show]
  get 'dashboard', to: 'dashboard#show'

  resources :loans, only: [:new, :show, :update] do
    collection do
      get 'get_co_borrower_info'
    end
  end

  resources :rates, only: [:index] do
    collection do
      post :select
    end
  end

  resources :properties, only: [] do
    collection do
      get :search
    end
  end

  resources :charges, only: [:new, :create]

  post 'electronic_signature/demo'
  get 'electronic_signature/embedded_response'

  resources :loan_activities, only: [:index, :show, :create] do
    collection do
      get 'get_activities_by_conditions'
    end
  end

end
