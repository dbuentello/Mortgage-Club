class RatesController < ApplicationController
  def index
    @loan = Loan.last
    zipcode = @loan.primary_property.address.zip

    bootstrap({
      currentLoan: LoanPresenter.new(@loan).edit
    })

    respond_to do |format|
      format.html { render template: 'borrower_app' }
      format.json { render json: RateServices::GetLenderRates.call(zipcode) }
    end
  end
end
