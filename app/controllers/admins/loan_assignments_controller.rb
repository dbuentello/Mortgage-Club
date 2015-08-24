class Admins::LoanAssignmentsController < Admins::BaseController
  before_action :set_loan, except: [:index]

  def index
    loans = Loan.all
    loan_members = LoanMember.all
    first_loan_associations = loans.first.loans_members_associations

    bootstrap(
      loans: LoansPresenter.new(loans).show,
      loan_members: LoanMembersPresenter.new(loan_members).show,
      associations: LoanMemberAssociationsPresenter.new(first_loan_associations).show
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def create
    loan_member = LoanMember.find(params[:loan_member_id])

    assignment = LoansMembersAssociation.find_or_initialize_by(
      loan_id: @loan.id,
      loan_member_id: loan_member.id
    )

    assignment.title = params[:title]
    assignment.save

    render json: {associations: reload_loans_members_associations_json}, status: 200
  end

  def destroy
    assignment = @loan.loans_members_associations.where(id: params[:id]).last

    return render json: {message: 'Assignment not found'}, status: 500 unless assignment

    if assignment.destroy
      render json: {
        message: "Remove the assigne sucessfully",
        associations: reload_loans_members_associations_json
      }, status: 200
    else
      render json: {message: "Cannot remove the assignee"}, status: 500
    end
  end

  def loan_members
    render json: {associations: reload_loans_members_associations_json}, status: 200
  end

  private

  def reload_loans_members_associations_json
    LoanMemberAssociationsPresenter.new(@loan.loans_members_associations).show
  end

end