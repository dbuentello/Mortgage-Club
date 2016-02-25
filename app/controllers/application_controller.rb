class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def find_root_path
    return unauthenticated_root_path unless current_user
    return admin_root_path if current_user.has_role?(:admin)
    return loan_member_root_path if current_user.has_role?(:lender_member)
    borrower_root_path
  end

  private

  def user_not_authorized
    @back_to_home_path = find_root_path
    render "errors/403.html", status: 403
  end

  def set_loan
    @loan ||= Loan.find(params[:loan_id] || params[:id])
    @borrower_type ||= :borrower

    if @loan.blank?
      @loan = current_user.borrower.loan # or get the co-borrower relationship

      if @loan.present?
        @borrower_type = :secondary_borrower
      else
        @loan = InitializeFirstLoanService.new(current_user).call
      end
    end
    authorize @loan, :update?
  end

  def bootstrap(data={})
    @bootstrap_data = {
      currentUser: {
        id: current_user.id,
        firstName: current_user.first_name,
        lastName: current_user.last_name
      },
      flashes: customized_flash
    }.merge!(data)
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

  def set_loan_edit_page
    @loan = Loan.find(params[:loan_id])
    @loan.own_investment_property = params[:own_investment_property]
    @loan.save
  end
end
