class UnderwritingController < ApplicationController
  def index
    @loan = Loan.find(params[:loan_id])

    bootstrap({
      currentLoan: LoanPresenter.new(@loan).edit,
    })
    render template: 'borrower_app'
  end

  def check_loan
    @loan = Loan.find(params[:loan_id])
    service = UnderwritingLoanServices::UnderwriteLoan.new(@loan)
    service.call
    if service.valid_loan?
      render json: {message: "ok"}
    else
      render json: {message: 'error', errors: service.error_messages}
    end
  end
end
