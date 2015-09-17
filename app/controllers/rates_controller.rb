class RatesController < ApplicationController
  def index
    @loan = Loan.first
    zipcode = @loan.property.address.zip
    bootstrap

    respond_to do |format|
      format.html { render template: 'borrower_app' }
      format.json { render json: RateServices::GetLenderRates.call(zipcode) }
    end
  end
end
