class Users::BorrowersController < Users::BaseController
  before_action :set_loan, only: [:edit, :update]

  def update
    @borrower_form = BorrowerForm.new(
      params: params, borrower: borrower, secondary_borrower: secondary_borrower,
      borrower_address: borrower_address, address: address
    )

    if @borrower_form.save
      if params[:remove_secondary_borrower] == "true"
        BorrowerServices::RemoveSecondaryBorrower.call(current_user, @loan, @borrower_type)
      end

      if params[:has_secondary_borrower] == "true"
        BorrowerServices::AssignSecondaryBorrowerToLoan.new(@loan, params, @borrower_form.secondary_borrower).call
      end

      @loan.reload

      render json: {loan: LoanPresenter.new(@loan).edit}
    else
      render json: {error: @borrower_form.errors.full_messages}, status: 500
    end
  end

  private

  def borrower
    @borrower ||= Borrower.find(params[:id])
  end

  def borrower_address
    @borrower_address ||= BorrowerAddress.find_by_id(params[:borrower_address_id])
  end

  def address
    @address ||= borrower.current_address.address
  end

  def secondary_borrower
    @secondary_borrower ||= @loan.secondary_borrower
  end
end
