class Users::DashboardController < Users::BaseController
  before_action :set_loan, only: [:show]

  def show
    return redirect_to edit_loan_path(@loan) if @loan.new_loan?

    property = @loan.subject_property
    closing = @loan.closing || Closing.create(name: 'Closing', loan_id: @loan.id)
    loan_activities = @loan.loan_activities.includes(loan_member: :user).recent_loan_activities(10)

    bootstrap(
      loan: LoanDashboardPage::LoanPresenter.new(@loan).show,
      address: property.address.try(:address),
      manager: LoanDashboardPage::LoanMemberPresenter.new(@loan.relationship_manager).show,
      loan_activities: loan_activities,
      contact_list: LoanDashboardPage::LoanMemberAssociationsPresenter.new(@loan.loans_members_associations).show,
      checklists: LoanDashboardPage::ChecklistsPresenter.new(@loan.checklists).show,
      borrower_documents: LoanDashboardPage::DocumentsPresenter.new(@loan.borrower.documents).show,
      closing_documents: LoanDashboardPage::DocumentsPresenter.new(closing.documents).show,
      property_documents: LoanDashboardPage::DocumentsPresenter.new(property.documents).show,
      loan_documents: LoanDashboardPage::DocumentsPresenter.new(@loan.documents).show,
      faqs_list: LoanDashboardPage::FaqsPresenter.new(Faq.all).show
    )

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end
end
