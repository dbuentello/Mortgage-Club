class LoanDashboardPage::LoanMemberAssociationsPresenter
  def initialize(loan_members_associations)
    @loan_members_associations = loan_members_associations
  end

  def show
    @loan_members_associations.includes(loan_member: :user).as_json(loan_members_associations_json_options)
  end

  private

  def loan_members_associations_json_options
    {
      include: [:loan_members_title,
        loan_member: {
          include: {
            user: {
              only: [ :email ],
              methods: [ :to_s , :avatar_url]
            }
          }
        }
      ]
    }
  end
end
