class UnderwritingController < ApplicationController
  def index
    @loan = Loan.find(params[:loan_id])

    bootstrap({
      currentLoan: LoanPresenter.new(@loan).edit,
    })
    render template: 'borrower_app'
  end
end
