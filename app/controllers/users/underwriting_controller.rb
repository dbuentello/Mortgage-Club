class Users::UnderwritingController < Users::BaseController
  def index
    @loan = Loan.find(params[:loan_id])

    return redirect_to edit_loan_url(@loan) unless @loan.completed?

    bootstrap(
      currentLoan: LoanEditPage::LoanPresenter.new(@loan).show
    )
    render template: "borrower_app"
  end

  def check_loan
    @loan = Loan.find(params[:loan_id])
    service = UnderwritingLoanServices::UnderwriteLoan.new(@loan)
    service.call
    if service.valid_loan?
      render json: {message: "ok"}
    else
      render json: {message: "error", errors: service.error_messages}
    end
  end
end
