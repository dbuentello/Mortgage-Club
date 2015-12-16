class SubmitApplicationToLenderService
  attr_accessor :loan, :staff, :error_message

  def initialize(loan, staff)
    @loan = loan
    @staff = staff
    @error_message = ""
  end

  def call
    return false unless valid?

    documents_info = get_documents_info
    templates_name = get_templates_name
    client_name = get_client_name

    LoanMemberMailer.submit_application({
      documents_info: get_documents_info,
      templates_name: get_templates_name,
      lender_name: loan.lender.name,
      lender_email: loan.lender.lock_rate_email,
      loan_member_name: staff.to_s,
      loan_member_email: "#{staff.to_s} <#{staff.email}>",
      client_name: get_client_name,
      loan_id: loan.id
    }).deliver_later
    true
  end

  def documents_are_incomlete?
    loan.required_lender_documents.count != loan.lender.lender_templates.where(is_other: false).count
  end

  private

  def valid?
    validate
    error_message.blank?
  end

  def validate
    return @error_message = "Loan is missing" unless loan
    return @error_message = "Loan does not belong to any lenders" unless loan.lender
    return @error_message = "Loan is not provided adequate documents" if documents_are_incomlete?
    return @error_message = "Don't know who is in charge of this loan" unless staff
  end

  def get_documents_info
    loan.lender_documents.map do |document|
      {
        url: Amazon::GetUrlService.call(document.attachment, 6.months.seconds),
        file_name: get_filename(document)
      }
    end
  end

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

  def get_filename(document)
    if document.lender_template.is_other
      filename = document.description + File.extname(document.attachment_file_name)
    else
      filename = document.lender_template.name + File.extname(document.attachment_file_name)
    end
    filename
  end
end
