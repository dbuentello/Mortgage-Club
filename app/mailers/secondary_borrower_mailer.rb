class SecondaryBorrowerMailer < ActionMailer::Base
  default :from => ENV['EMAIL_SENDER']

  def notify_being_added(loan_id)
    @loan = Loan.find loan_id

    @borrower = @loan.borrower
    @secondary_borrower = @loan.secondary_borrower

    mail(
      to: @secondary_borrower.user.email,
      subject: "You have been added as secondary borrower from #{@loan.user.to_s}"
    )
  end
end