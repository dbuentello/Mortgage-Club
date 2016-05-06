class LoanMembers::LoansController < LoanMembers::BaseController
  def index
    loans = current_user.loan_member.loans.includes(:user, properties: :address)

    loan_statuses = Loan.statuses.map { |key, _value| [key, key.titleize] }
    bootstrap(
      loans: LoanMembers::LoansPresenter.new(loans).show,
      loan_statuses: loan_statuses
    )
    respond_to do |format|
      format.html { render template: "loan_member_app" }
    end
  end

  def show_loan_terms
    @loan = Loan.find(params[:id])
    subject_property = @loan.subject_property
    property_address = subject_property.address ? subject_property.address : nil
    bootstrap(
      loan: LoanMembers::LoanPresenter.new(@loan).show,
      loan_writable_attributes: writable_loan_params,
      borrower: LoanMembers::BorrowerPresenter.new(@loan.borrower).show,
      property: LoanMembers::PropertyPresenter.new(subject_property).show,
      address: property_address
    )

    respond_to do |format|
      format.html { render template: 'loan_member_app' }
    end
  end

  def update
    loan = Loan.find(loan_id)
    if loan.update(loan_params)
      respond_to do |format|
        format.json { render json: {message: t("loan_members.loans.update.success")} }
      end
    end
  end

  def update_loan_terms
    byebug
    if LoanMemberServices::UpdateLoanTermsServices.new(loan_id, property_id, address_id, loan_terms_params, property_params, address_params).update_loan
      loan = Loan.find(loan_id)
      respond_to do |format|
        format.json { render json: {message: t("loan_members.loans.update.success"), loan: loan, property: loan.subject_property, address: loan.subject_property.address} }
      end
    else
      respond_to do |format|
        format.json { render json: {message: loan.errors.full_messages}, status: 500 }
      end
    end
  end

  private

  def property_id
    params[:property][:id]
  end

  def address_id
    params[:address][:id]
  end

  def loan_terms_params
    params.require(:loan).permit(Loan.get_editable_attributes)
  end

  def property_params
    params.require(:property).permit(Property::PERMITTED_ATTRS).reject { |_, value| value.blank? }
  end

  def address_params
    params.require(:address).permit(Address::PERMITTED_ATTRS).reject { |_, value| value.blank? }
  end

  def loan_params
    params.permit(:status)
  end

  def loan_id
    params[:id]
  end

  def writable_loan_params
    Loan.get_editable_attributes
  end

end
