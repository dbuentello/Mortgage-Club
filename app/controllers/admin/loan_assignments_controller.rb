class Admin::LoanAssignmentsController < Admin::BaseController

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

  def loan_members
    loan ||= Loan.find(params[:loan_id])
    # to get title and loan members
    render json: {associations: loan.loans_members_associations.as_json(associations_json_options)}, status: 200
  end

  private

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
      }
    }
  end
end