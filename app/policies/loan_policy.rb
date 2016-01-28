class LoanPolicy < ApplicationPolicy
  attr_reader :user, :loan
  # def new?
  #   # user.admin? or not record.published?

  # end

  # def show?

  # end

  def initialize(user, loan)
    @user = user
    @loan = loan
  end

  def edit?
    update?
  end

  def update?
    if user.has_role? :admin
      return true
    elsif user.has_role? :loan_member
      return user.loan_member.handle_this_loan?(loan)
    else
      return loan.user == user
    end
    false
  end

  def destroy?
    update?
  end

  # def get_co_borrower_info?

  # end
end
