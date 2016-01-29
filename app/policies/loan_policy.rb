class LoanPolicy < ApplicationPolicy
  attr_reader :user, :loan

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

  def show?
    update?
  end

  def destroy?
    update?
  end
end
