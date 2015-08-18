class Admin::DashboardController < Admin::BaseController
  def index
    @loan = Loan.all
    @loan_members = LoanMember.includes(:user).all
    render nothing: true
  end
end