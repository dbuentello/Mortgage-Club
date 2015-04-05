class LoansController < ApplicationController
  def new
    loan = current_user.loans.first || Loan.initiate(current_user)
    bootstrap({currentLoan: loan.as_json(json_options)})
    respond_to do |format|
      format.html { render template: 'client_app' }
    end
  end

  def show
    @loan = Loan.find(params[:id])
  end

  def create
    @loan = Loan.create(loan_params)
  end

  def update
    loan = current_user.loans.find(params[:id])
    if loan.update(loan_params)
      render json: {loan: loan.reload.as_json(json_options)}
    else
      render json: {error: loan.errors.full_messages}, status: 500
    end
  end

  private
    def loan_params
      params.require(:loan).permit(Loan::PERMITTED_ATTRS)
    end

    def json_options
      {
        :include => {
          :property => {
            :include => {:address => {}}
          },
          :borrower => {}
        },
        :methods => [:property_completed]
      }
    end
end
