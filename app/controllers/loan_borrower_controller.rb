class LoanBorrowerController < ApplicationController
  
  def show
    @loan_borrower = get_borrower
  end

  def create
    @loan = Loan.find(params[:id])
    @loan_borrower = is_secondary_borrower? ? 
      @loan.create_secondary_borrower(loan_borrower_params) :
      @loan.create_borrower(loan_borrower_params)
  end

  def update
    @loan_borrower = get_borrower
    if @loan_borrower.update(loan_borrower_params)
      @loan_borrower.reload
    else
      render json: {:message => 'Unable to update'}, status: 500
    end
  end

  private

    def get_borrower
      loan = Loan.find(params[:id])
      is_secondary_borrower? ? loan.secondary_borrower : loan.borrower
    end

    def is_secondary_borrower?
      params.try(:type) == 'is_secondary'
    end

    def loan_borrower_params
      params.require(:record).permit(Borrower::PERMITTED_ATTRS)
    end
end
