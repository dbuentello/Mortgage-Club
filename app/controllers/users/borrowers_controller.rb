class Users::BorrowersController < Users::BaseController
  before_action :set_loan, only: :update

  def update
    # check if borrower's ssn was changed.
    ssn_was_changed = ssn_was_changed?
    borrower_form = BorrowerForm.new(
      form_params: get_form_params(params[:borrower]), borrower: borrower,
      loan: @loan, is_primary_borrower: true
    )

    if borrower_form.save
      if applying_with_secondary_borrower? # there's a co-borrower
        assign_secondary_borrower_to_loan(secondary_borrower) if update_secondary_borrower
      else # remove if there is existing co-borrower
        remove_secondary_borrower
      end

      @loan.reload
      borrower.reload

      # only getting new credit report if ssn was changed
      get_credit_report if borrower_agrees_credit_check? && ssn_was_changed

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

  def get_credit_report
    CreditReportServices::Base.call(@loan)
  end

  def get_liabilities(borrower)
    return [] unless borrower.credit_report

    borrower.credit_report.liabilities
  end

  def ssn_was_changed?
    return true if borrower.ssn != params[:borrower][:borrower][:ssn]
    return true if @loan.secondary_borrower && @loan.secondary_borrower.ssn != params[:secondary_borrower][:borrower][:ssn]
    return true if params[:secondary_borrower][:borrower][:ssn] && !@loan.secondary_borrower
    false
  end

  def borrower_agrees_credit_check?
    @loan.credit_check_agree
  end
end
