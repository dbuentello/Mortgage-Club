class Admins::LoanAssignmentsController < Admins::BaseController
  before_action :load_loan, except: [:index]

  def index
    loans = Loan.all.includes(:user)
    loan_members = LoanMember.includes(:user).all

    bootstrap(
      loans: loans.as_json(loans_json_options),
      loan_members: loan_members.as_json(loan_members_json_options),
      associations: loans.first.loans_members_associations.includes(loan_member: :user).as_json(associations_json_options)
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def create
    loan_member = LoanMember.find(params[:loan_member_id])
    LoansMembersAssociation.find_or_create_by(
      loan_id: @loan.id,
      loan_member_id: loan_member.id,
      title: params[:title]
    )
    render json: {
      associations: reload_loans_members_associations_json
    }, status: 200
  end

  def destroy
    return unless assignment = @loan.loans_members_associations.where(id: params[:id]).last

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

  def load_loan
    @loan ||= Loan.find(params[:loan_id])
  end

  def reload_loans_members_associations_json
    @loan.loans_members_associations.includes(loan_member: :user).as_json(associations_json_options)
  end

  def loans_json_options
    {
      include: {
        user: {
          only: [ :email ],
          methods: [ :to_s ]
        }
      }
    }
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