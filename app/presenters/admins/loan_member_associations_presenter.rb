class Admins::LoanMemberAssociationsPresenter
  def initialize(loan_members_associations)
    @loan_members_associations = loan_members_associations
  end

  def show
    @loan_members_associations.includes(loan_member: :user).as_json(json_options)
  end

  private

  def json_options
    {
      include: {
        loan_member: {
          include: {
            user: {
              only: [ :email ],
              methods: [ :to_s , :avatar_url]
            }
          }
        }
      },
      methods: [ :pretty_title ]
    }
  end
end

# cucumber features/checklists.feature:3 # Scenario: add a new checklist
# cucumber features/checklists.feature:22 # Scenario: edit a new checklist
# cucumber features/income_tab_at_new_loan_page.feature:3 # Scenario: Borrower updates his income detail
# cucumber features/loan_member_managements.feature:3 # Scenario: add new member and with confirmation email
# cucumber features/loan_member_managements.feature:37 # Scenario: add new member and without confirmation email
# cucumber features/loan_member_managements.feature:63 # Scenario: edit a member
# cucumber features/loan_member_managements.feature:85 # Scenario: remove a member