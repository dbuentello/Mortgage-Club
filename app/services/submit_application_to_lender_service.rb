class SubmitApplicationToLenderService
  attr_reader :loan, :staff

  def initialize(loan, staff)
    @loan = loan
    @staff = staff
  end

  def call
    return false unless loan && loan.can_submit_to_lender && staff && @loan.lender

    documents_info = get_documents_info
    templates_name = get_templates_name
    client_name = get_client_name

    LoanMemberMailer.submit_application({
      documents_info: get_documents_info,
      templates_name: get_templates_name,
      lender_name: @loan.lender.name,
      lender_email: @loan.lender.lock_rate_email,
      loan_member_name: staff.to_s,
      loan_member_email: "#{staff.to_s} <#{staff.email}>",
      client_name: get_client_name,
      loan_id: loan.id
    }).deliver_later
    true
  end

  private

  def get_documents_info
    loan.lender_documents.map do |document|
      {
        url: Amazon::GetUrlService.call(document.attachment, 6.months.seconds),
        file_name: document.attachment_file_name
      }
    end
  end

  def get_client_name
    client_name = loan.borrower.user.to_s
    client_name << " and #{@loan.secondary_borrower.user.to_s}" if loan.secondary_borrower
    client_name
  end

  def get_templates_name
    @loan.lender.lender_templates.map { |template| template.name if template.is_other == false }.compact
  end
end
