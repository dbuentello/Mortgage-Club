class LoanMembers::LoansController < LoanMembers::BaseController
  def index
    loans = current_user.loan_member.loans.includes(:user, properties: :address)

    loan_statuses = Loan.statuses.map { |key, _value| [key, key.titleize] }
    bootstrap(
      loans: LoanMembers::LoansPresenter.new(loans).show,
      loan_statuses: loan_statuses
    )
    respond_to do |format|
      format.html { render template: 'loan_member_app' }
    end
  end

  def update
    loan = Loan.find(loan_id)
    if loan.update(loan_params)
      respond_to do |format|
        format.json { render json: {message: "Your loan has been saved successfully"} }
      end
    end
  end

  private

  def loan_params
    params.permit(:status)
  end

  def loan_id
    params[:id]
  end
end
