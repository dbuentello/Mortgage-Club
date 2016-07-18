class Users::CreditChecksController < Users::BaseController
  before_action :set_loan, only: :update

  def update
    @loan.update(credit_check_agree: credit_check_params[:credit_check_agree])

    if credit_check_params[:credit_check_agree] == "true"
      CreditReportServices::Base.call(@loan)
      @loan.reload
    end

    render json: {loan: LoanEditPage::LoanPresenter.new(@loan).show, liabilities: get_liabilities(@loan.borrower)}, status: 200
  end

  private

  def credit_check_params
    params.require(:credit_check).permit(:credit_check_agree)
  end

  def get_liabilities(borrower)
    return [] unless borrower.credit_report

    borrower.credit_report.liabilities
  end
end
