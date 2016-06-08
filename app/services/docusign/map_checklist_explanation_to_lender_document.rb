# create a lender document from Checklist's envelope.
# envelope is a Docusign's term. One envelope is a document which was signed.
module Docusign
  class MapChecklistExplanationToLenderDocument
    attr_reader :envelope_id, :user, :checklist, :loan

    def initialize(envelope_id, checklist_id, user_id)
      @envelope_id = envelope_id
      @checklist = Checklist.find_by_id(checklist_id)
      @user = User.find_by_id(user_id)
    end

    def call
      return false if envelope_id.blank?
      return false if invalid_checklist?
      return false if lender_template.nil?
      return false unless file_path = download_document_from_docusign(lender_template.template)

      LenderDocument.transaction do
        lender_document = LenderDocument.find_or_initialize_by(
          loan: checklist.loan,
          lender_template: lender_template
        )
        lender_document.description = lender_template.template.description
        lender_document.user = user
        lender_document.attachment = File.new(file_path)
        lender_document.save!
        File.delete(file_path)
      end
    end

    private

    def invalid_checklist?
      checklist.nil? || checklist.loan.nil? || checklist.template.nil?
    end

    def lender_template
      @lender_template ||= checklist.loan.lender_templates.where(template: checklist.template).last
    end

    def download_document_from_docusign(template)
      Docusign::DownloadDocumentService.call(envelope_id, template.name, 1)
    end
  end
end
