class LoanMemberMailer < ActionMailer::Base
  def submit_application(args)
    @args = args

    @args[:documents_info].each do |document|
      attachments[document[:file_name]] = open(document[:url]).read
    end

    # for demo purpose
    args[:lender_email] = "submission@mortgageclub.co"


    mail(
      from: args[:loan_member_email],
      to: args[:lender_email],
      subject: "Lock-in request for loan #<lender_loan_number>"
    )
  end
end
