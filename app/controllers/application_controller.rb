class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  private

    def bootstrap(data={})
      @bootstrap_data = {
        currentUser: current_user.present? ? {
          id: current_user.id,
          firstName: current_user.first_name,
          lastName: current_user.last_name
        } : {}
      }.merge!(data)
    end

    def current_user
      User.where(id: session[:user_id]).first
    end

    def redirect_if_auth
      if current_user
        redirect_to new_loan_path
      end
    end

end
