class Users::DashboardController < Users::BaseController
  before_action :set_loan, only: [:show]

  def show
    loan = @loan
    property = loan.property
    closing = loan.closing || Closing.create(name: 'Closing', loan_id: loan.id)
    loan_activities = loan.loan_activities.includes(loan_member: :user).recent_loan_activities(10)

    loan_presenter = LoanPresenter.new(loan)

    bootstrap(
      address: property.address.try(:address),
      loan: loan_presenter.show,
      borrower_list: BorrowerPresenter.new(current_user.borrower).show_documents,
      contact_list: LoanMemberAssociationsPresenter.new(loan.loans_members_associations).show,
      property_list: PropertyPresenter.new(property).show_documents,
      loan_list: loan_presenter.show_documents,
      manager: LoanMembersPresenter.show(loan.relationship_manager),
      loan_activities: loan_activities,
      closing_list: ClosingPresenter.new(closing).show_documents,
      checklists: ChecklistsPresenter.index(loan.checklists)
    )

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  def update_checklist_status
    checklist = Checklist.find(params[:checklist_id])

    if checklist.update(status: params[:status])
      render json: {message: 'Updated successfully'}, status: 200
    else
      render json: {message: "Cannot update the checklist"}, status: 500
    end
  end
end