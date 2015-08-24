class Admins::LoanAssignmentsController < Admins::BaseController
  before_action :set_loan, except: [:index]

  def index
    loans = Loan.preload(:user)
    loan_members = LoanMember.includes(:user)
    first_loan_associations = loans.first.loans_members_associations.includes(loan_member: :user)

    bootstrap(
      loans: LoansPresenter.new(loans).show_loans,
      loan_members: loan_members.as_json(loan_members_json_options),
      associations: first_loan_associations.as_json(associations_json_options)
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
    @loan.loans_members_associations.includes(loan_member: :user).as_json(associations_json_options)
  end

  def loan_members_json_options
    {
      include: {
        user: {
          only: [ :email ],
          methods: [ :to_s ]
        }
      }
    }
  end

  def associations_json_options
    {
      include: {
        loan_member: {
          include: {
            user: {
              only: [ :email ],
              methods: [ :to_s ]
            }
          }
        }
      },
      methods: [ :pretty_title ]
    }
  end

end