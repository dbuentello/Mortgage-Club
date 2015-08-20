class LoanMembers::BaseController < ApplicationController
  layout 'loan_member'

  before_action :authenticate_loan_member!

  private

  def authenticate_loan_member!
    unless current_user.loan_member?
      redirect_to loan_member_root_url, alert: "The page does not exist or you don't have permmission to access!"
    end
  end
end