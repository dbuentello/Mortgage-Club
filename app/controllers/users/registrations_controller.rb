class Users::RegistrationsController < Devise::RegistrationsController
  layout 'authentication'

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @token = params[:invite_token]
    @invite_code = params[:invite_code]

    super
  end

  # POST /resource
  def create
    super

    @token = params[:invite_token]
    @invite_code = params[:ref_code]

    if resource.persisted?
      # Update invite join_at
      InviteService.delay.call(@token, @invite_code, resource)
    end

    if params[:role] == "loan-owner"
      resource.create_borrower
      resource.add_role :borrower
    else
      resource.create_loan_member
      resource.add_role :loan_member
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) { |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    }
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit(:email, :password, :password_confirmation, :current_password, :avatar)
    }
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def update_resource(resource, params)
    if params[:current_password].present?
      resource.update_with_password(params)
    else
      params.delete(:current_password)
      resource.update_without_password(params)
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
