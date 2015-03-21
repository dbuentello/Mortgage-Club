class LoansController < ApplicationController
  def index
    @loans = Loan.all
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
      @loan.reload
    else
      render json: {:message => 'Unable to update'}, status: 500
    end
  end

  private

    def loan_params
      params.require(:record).permit(Loan::PERMITTED_ATTRS)
    end
end
