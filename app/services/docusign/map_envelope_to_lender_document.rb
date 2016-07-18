module Docusign
  #
  # Class MapEnvelopeToLenderDocument provides creating a lender document from Form's envelope.
  #
  # envelope is a Docusign's term. One envelope is a document which was signed.
  #
  class MapEnvelopeToLenderDocument
    attr_reader :envelope_id, :user, :loan
    # envelope_id is Docusign Envelope's id, not id of Envelope model

    def initialize(envelope_id, user_id, loan_id)
      @envelope_id = envelope_id
      @user = User.find_by_id(user_id)
      @loan = Loan.find_by_id(loan_id)
    end

    def call
      return false unless envelope_id.present? && user && loan && loan.lender

      LenderDocument.transaction do
        loan.lender_templates.each do |lender_template|
          next unless lender_template.docusign_envelope?
          next unless file_path = download_document_from_docusign(lender_template.template)

          lender_document = LenderDocument.find_or_initialize_by(
            loan: loan,
            lender_template: lender_template
          )
          lender_document.description = lender_template.template.description
          lender_document.user = user
          lender_document.attachment = File.new(file_path)
          lender_document.save!
          File.delete(file_path) if File.exist?(file_path)
        end
      end
      true
    end

    private

    def download_document_from_docusign(template)
      Docusign::DownloadDocumentService.call(envelope_id, template.name, template.document_order)
    end
  end
end
