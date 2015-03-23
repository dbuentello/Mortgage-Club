class LoansController < ApplicationController
  def new
    bootstrap
    respond_to do |format|
      format.html { render template: 'loans/app' }
    end
  end

  def show
    @loan = Loan.find(params[:id])
  end

  def create
    @loan = Loan.create(loan_params)
  end

  def update
    @loan = Loan.find(params[:id])
    if @loan.update(loan_params)
      @loan
    else
      render json: {error: 'Unable to update'}, status: 500
    end
  end

  private

    def loan_params
      params.require(:record).permit(Loan::PERMITTED_ATTRS)
    end
end
