class LoanActivityMailer < ActionMailer::Base
  default from: ENV['EMAIL_SENDER']

  def notify_to_borrower(borrower, email_subject, email_body)
    @first_name = borrower.user.first_name
    @email_body = email_body

    mail(
      to: borrower.user.email,
      subject: email_subject
    )
  end
end
