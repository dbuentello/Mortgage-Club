class LoanMembersPresenter
  def initialize(loan_members)
    @loan_members = loan_members
  end

  def show
    @loan_members.includes(:user).as_json(loan_members_json_options)
  end

  private

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

end