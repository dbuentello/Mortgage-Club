class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  private

    def bootstrap(data={})
      @bootstrap_data = {
        currentUser: current_user.present? ? {
          id: current_user.id,
          firstName: current_user.first_name,
          lastName: current_user.last_name
        } : {},
        flashes: customized_flash
      }.merge!(data)
    end

    def redirect_if_auth
      if current_user
        redirect_to new_loan_path
      end
    end

    def customized_flash
      customized_flash = {}
      flash.each do |msg_type, message|
        type = view_context.bootstrap_class_for(msg_type)

        if type.present?
          customized_flash[type] = message
        end
      end

      customized_flash
    end

end
