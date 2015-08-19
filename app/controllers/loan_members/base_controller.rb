class LoanMembers::BaseController < ApplicationController
  layout 'loan_member'

  before_action :authenticate_loan_member!

  private

  def authenticate_loan_member!
    unless current_user.loan_member?
      render status: :forbidden, text: "You don't have permmission to access this page!" and return
    end
  end
end