# For loan member. Get email info for SubmitApplicationToLender service.
module SubmissionServices
  class GetEmailInfo
    attr_accessor :loan, :loan_member, :staff

    def initialize(loan, loan_member, staff)
      @loan = loan
      @loan_member = loan_member
      @staff = staff
    end

    def call
      return unless loan && loan.lender && staff && loan_member

      templates_name = get_templates_name
      client_name = get_client_name

      {
        templates_name: templates_name,
        lender_name: loan.lender.name,
        lender_email: loan.lender.lock_rate_email,
        loan_member_name: staff.to_s,
        client_name: client_name,
        loan_member_title: loan_member.title(loan),
        loan_member_email: "#{staff} <#{staff.email}>",
        loan_member_short_email: staff.email,
        loan_member_phone_number: loan_member.phone_number,
        loan_id: loan.id
      }
    end

    private

    def get_client_name
      client_name = loan.borrower.user.to_s
      client_name << " and #{@loan.secondary_borrower.user}" if loan.secondary_borrower
      client_name
    end

    def get_templates_name
      templates_name = loan.lender.lender_templates.includes(:lender_documents).order(:is_other).map do |lender_template|
        lender_template.is_other? ? lender_template.lender_documents.map(&:description) : lender_template.description
      end
      templates_name.flatten!
    end
  end
end
