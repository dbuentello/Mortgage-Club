class RemindBorrowerMailer < ActionMailer::Base
  default from: "Billy Tran <billy@mortgageclub.co>"

  def remind_checklists(loan)
    @first_name = loan.borrower.user.first_name
    @checklists = loan.checklists.where(status: "pending").order(created_at: :asc)
    @loan_member = loan.loan_members.first
    @closing_date = loan.closing_date

    mail(
      to: loan.borrower.user.email,
      subject: "[ACTION NEEDED] Your loan application for #{loan.subject_property.address.address}"
    )
  end
end
