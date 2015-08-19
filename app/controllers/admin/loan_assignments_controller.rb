class Admin::LoanAssignmentsController < Admin::BaseController

  def index
    @loans = Loan.all.includes(:user)
    @loan_members = LoanMember.includes(:user).all

    bootstrap(loans: @loans.as_json(loans_json_options))

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  private

  def loans_json_options
    {
      include: {
        user: {
          only: [ :email ],
          methods: [ :to_s ]
        },
      }
    }
  end
end