class LoanMembers::LoansController < LoanMembers::BaseController
  def index
    loans = current_user.loan_member.loans

    bootstrap(loans: LoansPresenter.new(loans).show)

    respond_to do |format|
      format.html { render template: 'loan_member_app' }
    end
  end
end