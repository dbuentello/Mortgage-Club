class Admins::LoanMembersPresenter
  def initialize(loan_members)
    @loan_members = loan_members
  end

  def show
    @loan_members.includes(user: :roles).as_json(json_options)
  end

  private

  def json_options
    {
      include: {
        user: {
          only: [:email, :first_name, :last_name],
          methods: [:avatar_url]
        }
      }
    }
  end
end
