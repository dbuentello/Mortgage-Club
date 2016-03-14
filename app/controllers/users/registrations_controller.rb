class Users::RegistrationsController < Devise::RegistrationsController
  layout 'authentication'

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  prepend_before_action :check_captcha, only: [:create]

  # GET /resource/sign_up
  def new
    @token = params[:invite_token]
    @invite_code = params[:invite_code]

    super
  end

  # POST /resource
  def create
    super

    if resource.persisted?
      # Update invite join_at
      @token = params[:invite_token]
      @invite_code = params[:ref_code]
      InviteService.delay.call(@token, @invite_code, resource)

      resource.create_borrower
      resource.add_role :borrower
      resource.confirmed_at = Time.zone.now
      resource.skip_confirmation_notification!
      resource.save

      sign_in resource_name, resource, bypass: true
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      else
        message = update_needs_confirmation?(resource, prev_unconfirmed_email) ? "Update need confirmation" : "Update successfully"
      end
      sign_in resource_name, resource, bypass: true

      if request.format == "application/json"
        if resource.errors.empty?
          return render json: {message: message, user: LoanListPage::UserPresenter.new(resource).show}, status: 200
        else
          render json: {message: resource.errors.full_messages}, status: 500
        end
      else
        respond_with resource, location: after_update_path_for(resource)
      end
    else
      return render_error if request.format == "application/json"

      clean_up_passwords resource
      respond_with resource
    end
  end

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

  def render_error
    render json: {
      first_name: resource.errors.messages[:first_name].try(:first),
      last_name: resource.errors.messages[:last_name].try(:first),
      email: resource.errors.messages[:email].try(:first),
      password: resource.errors.messages[:password].try(:first),
      current_password: resource.errors.messages[:current_password].try(:first),
      password_confirmation: resource.errors.messages[:password_confirmation].try(:first),
    }, status: 500
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) { |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    }
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit(:email, :first_name, :last_name, :password, :password_confirmation, :current_password, :avatar)
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

  def after_sign_up_path_for(resource)
    borrower_root_path
  end

  private

  def check_captcha
    if verify_recaptcha
      true
    else
      flash.delete :recaptcha_error
      self.resource = resource_class.new sign_up_params
      resource.errors.add(:recaptcha_error, "Please confirm you're not a robot!")
      respond_with_navigational(resource) { render :new }
    end
  end
end
