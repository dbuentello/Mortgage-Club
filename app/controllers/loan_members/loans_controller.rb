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

  def update
    loan = Loan.find(loan_id)
    if loan.update(loan_params)
      respond_to do |format|
        format.json { render json: {message: t("loan_members.loans.update.success")} }
      end
    end
  end

  def update_loan_terms
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

  def update_loan_terms_old

    loan = Loan.find(loan_id)
    if update_property
      if loan.update(loan_terms_params)
        loan = loan.reload
        property = loan.subject_property
        respond_to do |format|
          format.json { render json: {message: t("loan_members.loans.update.success"), loan: loan, property: property, address: property.address} }
        end
      else
        respond_to do |format|
          format.json { render json: {message: t("loan_members.loans.update.failed")}, status: 500 }
        end
      end
    else
      respond_to do |format|
        format.json { render json: {message: t("loan_members.loans.update.failed")}, status: 500 }
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
    params.require(:property).permit(Property::PERMITTED_ATTRS).reject{ |_, value| value.blank? }
  end

  def address_params
    params.require(:address).permit(Address::PERMITTED_ATTRS).reject{ |_, value| value.blank? }
  end

  def update_property
    property = Property.find(property_params[:id])
    create_or_update_address(property)
    property.update(property_params)
  end

  def create_or_update_address(property)
    address_params = params.require(:address).permit(Address::PERMITTED_ATTRS).reject { |_, value| value.blank? }
    if address_params[:id].present?
      address = Address.find(address_params[:id])
      address.update(address_params.except(:id))
    else
      property.build_address(address_params.except(:id))
      property.address.save
    end
  end

  def loan_params
    params.permit(:status)
  end

  def loan_id
    params[:id]
  end
end
