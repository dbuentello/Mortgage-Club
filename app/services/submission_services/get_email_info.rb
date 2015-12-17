module SubmissionServices
  class GetEmailInfo
    attr_accessor :loan, :staff, :error_message

    def initialize(loan, staff)
      @loan = loan
      @staff = staff
    end

    def call
      return false unless loan && loan.lender && staff

      templates_name = get_templates_name
      client_name = get_client_name

      {
        templates_name: get_templates_name,
        lender_name: loan.lender.name,
        lender_email: loan.lender.lock_rate_email,
        loan_member_name: staff.to_s,
        loan_member_email: "#{staff.to_s} <#{staff.email}>",
        client_name: get_client_name,
        loan_id: loan.id
      }
    end

    def documents_are_incomlete?
      loan.required_lender_documents.count != loan.lender.lender_templates.where(is_other: false).count
    end

    private

    def get_client_name
      client_name = loan.borrower.user.to_s
      client_name << " and #{@loan.secondary_borrower.user.to_s}" if loan.secondary_borrower
      client_name
    end

    def get_templates_name
      templates_name = loan.lender.lender_templates.order(:is_other).map do |lender_template|
        lender_template.is_other? ? lender_template.lender_documents.map { |document| document.description } : lender_template.description
      end
      templates_name.flatten!
    end
  end
end
