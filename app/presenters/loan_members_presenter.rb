class LoanMembersPresenter
  def self.index(loan_members)
    loan_members.includes(:user).as_json(loan_members_json_options)
  end

  def self.show(loan_member)
    loan_member.as_json(loan_members_json_options)
  end

  private

  def self.loan_members_json_options
    {
      include: {
        user: {
          only: [ :email ],
          methods: [ :to_s, :avatar_url ]
        }
      }
    }
  end
end
