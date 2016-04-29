class LoanDashboardPage::LoanMemberPresenter
  def initialize(loan_member)
    @loan_member = loan_member
  end

  def show
    @loan_member.as_json(json_options)
  end

  private

  def json_options
    {
      only: [:phone_number],
      include: {
        user: {
          only: [:email, :first_name, :last_name],
          methods: [:to_s, :avatar_url]
        }
      }
    }
  end
end
