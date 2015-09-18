class RatesController < ApplicationController
  def index
    if params[:loan_id]
      @loan = Loan.find(params[:loan_id])
    else
      @loan = Loan.last
    end
    zipcode = @loan.property.address.zip
    bootstrap

    respond_to do |format|
      format.html { render template: 'borrower_app' }
      format.json { render json: RateServices::GetLenderRates.call(zipcode) }
    end
  end
end
