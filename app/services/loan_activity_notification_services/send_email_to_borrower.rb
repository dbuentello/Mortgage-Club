module LoanActivityNotificationServices
  class SendEmailToBorrower
    def self.call(loan_activity)
      activity_type = loan_activity.activity_type
      activity_name = activity_type.activity_names.where(name: loan_activity.name).first

      if activity_name && activity_name.notify_borrower_email
        LoanActivityMailer.notify_to_borrower(loan_activity.loan.borrower, activity_name.notify_borrower_email_subject, activity_name.notify_borrower_email_body).deliver_later
      end
    end
  end
end
