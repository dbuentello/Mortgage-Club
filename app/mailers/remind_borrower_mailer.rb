class RemindBorrowerMailer < ActionMailer::Base
  default from: "Billy Tran <billy@mortgageclub.co>"

  def remind_checklists(loan)
    mortgage_advisor_title = LoanMembersTitle.find_by_title("Mortgage Advisor")
    loan_analyst_title = LoanMembersTitle.find_by_title("Loan Analyst")

    @first_name = loan.borrower.user.first_name
    @checklists = loan.checklists.where(status: "pending").order(created_at: :asc)

    @loan_member = LoanMember.joins(:loans_members_associations).where(loans_members_associations: {loan_id: loan.id, loan_members_title_id: mortgage_advisor_title.id}).first
    loan_analyst = LoanMember.joins(:loans_members_associations).where(loans_members_associations: {loan_id: loan.id, loan_members_title_id: loan_analyst_title.id}).first

    @closing_date = loan.closing_date

    email_cc = loan_analyst ? "#{@loan_member.user.email}, #{loan_analyst.user.email}" : @loan_member.user.email

    mail(
      to: loan.borrower.user.email,
      cc: email_cc,
      subject: "[ACTION NEEDED] Your loan application for #{loan.subject_property.address.address}"
    )
  end
end
