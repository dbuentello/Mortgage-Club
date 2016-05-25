class LoanMembers::LoanUrlTokensController < LoanMembers::BaseController
  before_action :set_loan, only: :create

  def create
    GeneratePreparedLoanUrlTokenService.call(@loan)

    render json: {
      loan: LoanMembers::LoanPresenter.new(@loan).show
    }, status: 200
  end
end
