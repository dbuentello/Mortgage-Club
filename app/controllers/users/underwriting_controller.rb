#
# Class Users::UnderwritingController provides methods to show underwriting page and check loan valid
#
# @author Tang Nguyen <tang@mortgageclub.co>
#
class Users::UnderwritingController < Users::BaseController
  #
  # Underwriting Page
  #
  # @return [HTML] borrower app with bootstrap data includes current loan
  #
  def index
    @loan = Loan.find(params[:loan_id])

    return redirect_to edit_loan_url(@loan) unless @loan.completed?

    bootstrap(
      currentLoan: LoanEditPage::LoanPresenter.new(@loan).show
    )
    render template: "borrower_app"
  end

  #
  # Check loan is valid or not
  #
  # @return [JSON] message with value is ok or error
  #
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
