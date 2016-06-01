class Users::BorrowersController < Users::BaseController
  before_action :set_loan, only: [:update]

  def update
    borrower_form = BorrowerForm.new(
      form_params: get_form_params(params[:borrower]), borrower: borrower,
      loan: @loan, is_primary_borrower: true
    )

    if borrower_form.save
      get_credit_report(borrower)
      if applying_with_secondary_borrower?
        assign_secondary_borrower_to_loan(secondary_borrower) if update_secondary_borrower
      else
        remove_secondary_borrower
      end

      @loan.reload
      borrower.reload

      render json: {loan: LoanEditPage::LoanPresenter.new(@loan).show, liabilities: get_liabilities(borrower)}
    else
      render json: {error: borrower_form.errors.full_messages}, status: 500
    end
  end

  def get_company_info
    render json: {company_info: FullContactServices::GetCompanyInfo.new(params[:domain]).call}
  end

  private

  def update_secondary_borrower
    secondary_borrower_form = BorrowerForm.new(
      form_params: get_form_params(params[:secondary_borrower]),
      borrower: secondary_borrower, loan: @loan
    )
    get_credit_report(secondary_borrower, true) if secondary_borrower_form.save
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

  def get_credit_report(borrower, run_in_background = false)
    return unless borrower.current_address && borrower.current_address.address

    if run_in_background
      CreditReportServices::Base.delay.call(borrower, borrower.current_address.address)
    else
      CreditReportServices::Base.call(borrower, borrower.current_address.address)
    end
  end

  def get_liabilities(borrower)
    borrower.credit_report.liabilities
  end
end
