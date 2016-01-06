class Users::BorrowersController < Users::BaseController
  before_action :set_loan, only: [:update]

  def update
    borrower_form = BorrowerForm.new(
      form_params: get_form_params(params[:borrower]), borrower: borrower,
      loan: @loan, is_primary_borrower: true
    )

    if borrower_form.save
      if applying_with_secondary_borrower?
        assign_secondary_borrower_to_loan(secondary_borrower) if update_secondary_borrower
      else
        remove_secondary_borrower
      end

      @loan.reload
      render json: {loan: LoanEditPage::LoanPresenter.new(@loan).show}
    else
      render json: {error: borrower_form.errors.full_messages}, status: 500
    end
  end

  private

  def update_secondary_borrower
    secondary_borrower_form = BorrowerForm.new(
      form_params: get_form_params(params[:secondary_borrower]),
      borrower: secondary_borrower, loan: @loan
    )
    secondary_borrower_form.save
  end

  def assign_secondary_borrower_to_loan(secondary_borrower)
    BorrowerServices::AssignSecondaryBorrowerToLoan.new(@loan, params[:secondary_borrower], secondary_borrower).call
  end

  def remove_secondary_borrower
    BorrowerServices::RemoveSecondaryBorrower.call(current_user, @loan, @borrower_type)
  end

  def applying_with_secondary_borrower?
    params[:has_secondary_borrower] && params[:has_secondary_borrower] == "true"
  end

  def borrower
    @borrower ||= Borrower.find(params[:id])
  end

  def secondary_borrower
    @loan.secondary_borrower || Borrower.new(loan: @loan)
  end

  def get_form_params(borrower_params)
    {
      current_address: borrower_params.require(:current_address).permit(Address::PERMITTED_ATTRS),
      previous_address: borrower_params.require(:previous_address).permit(Address::PERMITTED_ATTRS),
      current_borrower_address: borrower_params.require(:current_borrower_address).permit(BorrowerAddress::PERMITTED_ATTRS),
      previous_borrower_address: borrower_params.require(:previous_borrower_address).permit(BorrowerAddress::PERMITTED_ATTRS),
      borrower: borrower_params.require(:borrower).permit(Borrower::PERMITTED_ATTRS),
      loan_id: params[:loan_id]
    }
  end
end
