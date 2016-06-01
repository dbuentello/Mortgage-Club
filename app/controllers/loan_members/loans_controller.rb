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
    loan = Loan.find(params[:id])
    UpdateLoanTermsService.new(loan, params).call

    render json: {
      loan: LoanEditPage::LoanPresenter.new(loan).show,
      property: LoanMembers::PropertyPresenter.new(loan.subject_property).show
    }
  end

  def export_xml
    loan = Loan.find(params[:id])
    xml = ExportXmlMismoService.new(loan, loan.borrower).call

    send_data xml, type: "text/xml; charset=UTF-8;", disposition: "attachment; filename=entries.xml"
  end

  private

  def loan_params
    params.permit(:status)
  end

  def loan_id
    params[:id]
  end
end
