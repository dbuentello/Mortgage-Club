class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  # before_action :set_sample_flash

  private

    def set_sample_flash
      flash[:success] = "save successfully"
    end

    def bootstrap(data={})
      @bootstrap_data = {
        currentUser: current_user.present? ? {
          id: current_user.id,
          firstName: current_user.first_name,
          lastName: current_user.last_name
        } : {},
        flashes: flash_customized
      }.merge!(data)
    end

    def redirect_if_auth
      if current_user
        redirect_to new_loan_path
      end
    end

    def flash_customized
      flash_customized = {}
      flash.each do |msg_type, message|
        case msg_type
        when "success"
          type = "alert-success"
        when "error"
          type = "alert-danger"
        when "alert"
          type = "alert-warning"
        when "notice"
          type = "alert-info"
        end
        flash_customized[type] = message
      end

      flash_customized
    end

end
