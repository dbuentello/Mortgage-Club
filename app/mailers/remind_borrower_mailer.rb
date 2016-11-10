class RemindBorrowerMailer < ActionMailer::Base
  default from: "Billy Tran <billy@mortgageclub.co>"

  def remind_checklists(loan)
    @first_name = loan.borrower.user.first_name
    @checklists = loan.checklists.where(status: "pending")
    @loan_member = loan.loan_members.first

    mail(
      to: loan.borrower.user.email,
      subject: "[ACTION NEEDED] Your loan application for #{loan.subject_property.address.address}"
    )
  end
end
