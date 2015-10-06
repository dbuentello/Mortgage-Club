class RatesController < ApplicationController
  def index
    @loan = Loan.find(params[:loan_id])
    zipcode = @loan.primary_property.address.zip
    rates = RateServices::GetLenderRates.call(zipcode)

    bootstrap({
      currentLoan: LoanPresenter.new(@loan).edit,
      rates: rates
    })

    render template: 'borrower_app'
  end
end
