class Users::DashboardController < Users::BaseController
  before_action :set_loan, only: [:show]

  def show
    property = @loan.subject_property
    closing = @loan.closing || Closing.create(name: 'Closing', loan_id: @loan.id)
    loan_activities = @loan.loan_activities.includes(loan_member: :user).recent_loan_activities(10)

    bootstrap(
      loan: LoanPresenter.new(@loan).show,
      address: property.address.try(:address),
      manager: LoanMembersPresenter.show(@loan.relationship_manager),
      loan_activities: loan_activities,
      contact_list: LoanMemberAssociationsPresenter.new(@loan.loans_members_associations).show,
      checklists: ChecklistsPresenter.index(@loan.checklists),
      borrower_documents: DocumentsPresenter.new(@loan.borrower.documents).show,
      closing_documents: DocumentsPresenter.new(closing.documents).show,
      property_documents: DocumentsPresenter.new(property.documents).show,
      loan_documents: DocumentsPresenter.new(@loan.documents).show
    )

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end
end