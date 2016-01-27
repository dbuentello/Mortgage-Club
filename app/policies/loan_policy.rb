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
    @loan.user == @user
  end

  def destroy?
    update?
  end

  # def get_co_borrower_info?

  # end
end
