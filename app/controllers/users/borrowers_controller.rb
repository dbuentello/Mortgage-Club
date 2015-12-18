class Users::BorrowersController < Users::BaseController
  before_action :set_loan, only: [:update]

  def update
    form_params = get_form_params(params[:borrower])
    current_address = (borrower.current_address.present? ? borrower.current_address.address : form_params[:current_borrower_address])
    borrower_form = BorrowerForm.new(
      form_params: form_params, borrower: borrower,
      current_borrower_address: (borrower.current_address||form_params[:current_borrower]),
      current_address: current_address,
      loan: @loan
    )

    if borrower_form.save
      if applying_with_secondary_borrower?
        secondary_borrower_form = BorrowerForm.new(
          form_params: get_form_params(params[:secondary_borrower]), borrower: secondary_borrower,
          current_borrower_address: secondary_current_borrower_address, current_address: secondary_current_address,
          loan: @loan, is_secondary_borrower: true
        )
        if secondary_borrower_form.save
          BorrowerServices::AssignSecondaryBorrowerToLoan.new(@loan, params[:secondary_borrower], secondary_borrower_form.borrower).call
        end
      else
        BorrowerServices::RemoveSecondaryBorrower.call(current_user, @loan, @borrower_type)
      end

      @loan.reload

      render json: {loan: LoanPresenter.new(@loan).edit}
    else
      render json: {error: borrower_form.errors.full_messages}, status: 500
    end
  end

  private

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

  def secondary_current_borrower_address
    return BorrowerAddress.new unless secondary_borrower.current_address
    @loan.secondary_borrower.current_address
  end

  def secondary_current_address
    return Address.new unless secondary_borrower.current_address && secondary_borrower.current_address.address
    @loan.secondary_borrower.current_address.address
  end
end
