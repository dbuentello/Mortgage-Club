class RatesController < ApplicationController
  before_action :set_loan

  def index
    zipcode = @loan.property.address.zip
    bootstrap

    respond_to do |format|
      format.html { render template: 'borrower_app' }
      format.json { render json: RateServices::GetLenderRates.call(zipcode) }
    end
  end
end
