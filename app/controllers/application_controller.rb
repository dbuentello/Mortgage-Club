class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  private

  def set_loan
    return if current_user.loan_member?

    @loan = Loan.find(params[:id])
    @borrower_type = :borrower

    if @loan.blank?
      @loan = current_user.borrower.loan # or get the co-borrower relationship

      if @loan.present?
        @borrower_type = :co_borrower
      else
        @loan = Loan.initiate(current_user) # or create branch new one
      end
    end
  end

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
    return unless current_user

    if current_user.loan_member?
      redirect_to loan_activities_path
    elsif current_user.admin?
      # sign_out current_user
      redirect_to loan_assignments_path
    else
      redirect_to loans_dashboard_index_path
    end
  end

  def customized_flash
    customized_flash = {}
    flash.each do |msg_type, message|
      type = bootstrap_class_for(msg_type)

      if type.present?
        customized_flash[type] = message
      end
    end

    customized_flash
  end

end
