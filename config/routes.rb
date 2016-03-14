Rails.application.routes.draw do
  get "home_test_rates", to: "pages#home_test_rates"
  get "backend_test", to: "pages#backend_test"
  get "frontend_test", to: "pages#frontend_test"

  get "rate_drop_alert", to: "ab_testings#rate_drop_alert"
  post "/rate_drop_alert", to: "potential_rate_drop_users#create"

  post "/potential_users", to: "potential_users#create"
  post "mailjet_tracking", to: "mailjet_tracking#track"

  get "/esigning/:id", to: "users/electronic_signature#new"

  authenticated :user, ->(u) { u.has_role?(:borrower) } do
    root to: "users/loans#index", as: :borrower_root
  end

  authenticated :user, ->(u) { u.has_role?(:loan_member) } do
    root to: "loan_members/loans#index", as: :loan_member_root
  end

  authenticated :user, ->(u) { u.has_role?(:admin) } do
    root to: "admins/loan_assignments#index", as: :admin_root
  end

  unauthenticated do
    root "pages#index", as: :unauthenticated_root
  end

  devise_for :users,
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      confirmations: "users/confirmations",
      passwords: "users/passwords",
      unlocks: "users/unlocks"
    },
    path: "auth",
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      password: "secret",
      confirmation: "verification",
      unlock: "unblock",
      registration: "register",
      sign_up: "signup"
    }

  devise_scope :user do
    get "login", to: "users/sessions#new", as: :custom_login
    get "signup", to: "users/registrations#new", as: :custom_signup
  end

  get "/my/loans", to: "users/loans#index", as: :my_loans

  scope module: "users" do
    scope "/my" do
      # resources :loans do
      # end

      resources :dashboard, only: [:show] do
      end

      resources :checklists, only: [:update] do
        collection do
          get :load_docusign
          get :docusign_callback
        end
      end
    end

    resources :loans, except: [:new]

    resources :borrowers, only: [:update]
    resources :assets, path: "borrower_assets", only: [:create]
    resources :liabilities, only: [:create]

    resources :properties, only: [:create, :destroy] do
      collection do
        get :search
      end
    end

    resources :electronic_signature, only: [:new, :create] do
      get "embedded_response", on: :collection
    end

    resources :invites, only: [:create]

    resources :rates, only: [:index]

    resources :underwriting, only: [:index] do
      collection do
        get :check_loan
      end
    end
  end


  namespace :loan_members do
    resources :loan_activities, only: [:create] do
      collection do
        get "get_activities_by_conditions"
      end
    end

    resources :checklists, only: [:create, :edit, :update, :destroy] do
    end

    resources :loans, only: [:index, :update] do
    end

    resources :dashboard, only: [:show]

    resources :lender_documents, only: [:create, :destroy] do
      member do
        get "download"
      end

      collection do
        get "get_other_documents"
      end
    end

    resources :submissions, only: [] do
      collection do
        post "submit_to_lender"
        get "get_email_info"
      end
    end
  end

  scope module: "admins" do
    resources :loan_assignments, only: [:index, :create, :destroy] do
      collection do
        get :loan_members
      end
    end

    resources :loan_member_managements, only: [:index, :edit, :update, :create, :destroy] do
    end

    resources :homepage_rates, only: [:index, :edit, :update]

    resources :loan_faq_managements, except: [:new, :show]

    resources :loan_activity_type_managements, except: [:new, :show]

    resources :potential_user_managements, only: [:index, :edit, :update, :destroy] do
    end

    resources :potential_rate_drop_user_managements, only: [:index, :edit, :update, :destroy] do
    end

    resources :lenders, except: [:show] do
      resources :lender_templates, except: [:new, :show]
    end

    resources :loan_members_titles, except: [:new, :show]
    resources :settings, only: [:index, :update]
    resources :borrower_managements, only: [:index, :destroy] do
      member do
        get "switch"
      end
    end
  end

  namespace :document_uploaders do
    resources :base_document, only: [:destroy] do
      collection do
        post "upload"
      end

      member do
        get "download"
      end
    end
  end

  resources :ocr_notifications, only: [] do
    post "receive", on: :collection
  end

  resources :initial_quotes, only: [:index, :show, :create], path: "quotes" do
    collection do
      post "save_info"
    end
  end

  post "receive", to: "ocr_notifications#receive"

  get "developer_infographics", to: "pages#developer_infographics"

  get "*path", to: "errors#show", code: 404
end
