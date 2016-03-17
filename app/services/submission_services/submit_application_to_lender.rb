module SubmissionServices
  class SubmitApplicationToLender
    attr_accessor :loan, :staff, :email_subject, :email_content, :error_message

    def initialize(loan, staff, email_subject, email_content)
      @loan = loan
      @staff = staff
      @email_subject = email_subject
      @email_content = email_content
      @error_message = ""
    end

    def call
      return false unless valid?

      LoanMemberMailer.submit_application(
        documents_info: get_documents_info,
        loan_member_email: "#{staff} <#{staff.email}>",
        email_content: email_content,
        email_subject: email_subject,
        loan_id: loan.id
      ).deliver_later
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
      return @error_message = "Email's subject cannot be blank" if email_subject.blank?
      @error_message = "Email's content cannot be blank" if email_content.blank?
    end

    def get_documents_info
      loan.lender_documents.map do |document|
        {
          url: Amazon::GetUrlService.call(document.attachment, 6.months.seconds),
          file_name: get_filename(document)
        }
      end
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
end
