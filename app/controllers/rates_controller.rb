class RatesController < ApplicationController
  def index
    @loan = Loan.find(params[:loan_id])
    rates = []

    if @loan.primary_property.address && zipcode = @loan.primary_property.address.zip
      rates = ZillowService::GetMortgageRates.new(@loan.id, zipcode).call
    end

    bootstrap({
      currentLoan: LoanPresenter.new(@loan).edit,
      rates: rates
    })

    render template: 'borrower_app'
  end
end
