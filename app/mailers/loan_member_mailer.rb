class LoanMemberMailer < ActionMailer::Base
  def submit_application(args)
    @args = args

    @args[:documents_info].each do |document|
      attachments[document[:file_name]] = open(document[:url]).read
    end

    # for demo purpose
    # @args[:lender_email] = "submission@mortgageclub.co"
    @args[:lender_email] = "cuongvu0103@gmail.com"

    mail(
      from: @args[:loan_member_email],
      to: @args[:lender_email],
      subject: @args[:email_subject],
      "X-MJ-CustomID" => "Lock Loan - #{@args[:loan_id]}"
    )
  end
end
