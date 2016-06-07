class LeadRequestsMailer < ActionMailer::Base
  def send_request(user, loan_id)
    loan = Loan.find(loan_id)
    @user = user
    @borrower_name = loan.borrower.user.to_s
    if loan.subject_property && loan.subject_property.address && loan.subject_property.address.street_address
      @property_name = loan.subject_property.address.address
    else
      @property_name = "Unknown Address"
    end

    mail(
      from: "#{user} <#{user.email}>",
      to: "admin@mortgageclub.co",
      subject: "I'd like to claim a loan"
    )
  end
end
