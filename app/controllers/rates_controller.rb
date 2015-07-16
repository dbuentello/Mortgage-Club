class RatesController < ApplicationController
  def index
    bootstrap

    respond_to do |format|
      format.html { render template: 'client_app' }
      format.json { render json: Rate.get_rates }
    end
  end

  def select
    rate = params["rate"]
    current_loan = current_user.loans.first

    # current_loan.attributes = { }
    # current_loan.save

    render json: { message: "save loan successfully" }, status: :ok
  end

end
