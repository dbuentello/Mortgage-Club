class LoanMembers::BaseController < ApplicationController
  layout 'loan_member'
  before_action :authenticate_loan_member!

  def authenticate_loan!
    if @loan && !current_user.loan_member.handle_this_loan?(@loan)
      redirect_to unauthenticated_root_path, alert: "The page does not exist or you don't have permmission to access!"
    end
  end

  private

  def authenticate_loan_member!
    unless current_user.loan_member?
      redirect_to unauthenticated_root_path, alert: "The page does not exist or you don't have permmission to access!"
    end
  end
end
