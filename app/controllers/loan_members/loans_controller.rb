class LoanMembers::LoansController < LoanMembers::BaseController
  def index
    loans = current_user.loan_member.loans.includes(:user, properties: :address)

    bootstrap(loans: LoanMembers::LoansPresenter.new(loans).show)

    respond_to do |format|
      format.html { render template: 'loan_member_app' }
    end
  end
end