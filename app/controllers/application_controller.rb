class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  private

  def set_loan
    @loan = current_user.loans.first # get the first own loan
    if @loan.present?
      @borrower_type = :borrower
    else
      @loan = current_user.borrower.loan # or get the co-borrower relationship

      if @loan.present?
        @borrower_type = :secondary_borrower
      else
        @loan = Loan.initiate(current_user) # or create branch new one

        @borrower_type = :borrower
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
    if current_user
      redirect_to new_loan_path
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
