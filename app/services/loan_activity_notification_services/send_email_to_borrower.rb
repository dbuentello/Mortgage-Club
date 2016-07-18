module LoanActivityNotificationServices
  class SendEmailToBorrower
    def self.call(loan_activity)
      activity_type = loan_activity.activity_type

      if activity_type.notify_borrower_email
        LoanActivityMailer.notify_to_borrower(loan_activity.loan.borrower, activity_type.notify_borrower_email_subject, activity_type.notify_borrower_email_body).deliver_later
      end
    end
  end
end
