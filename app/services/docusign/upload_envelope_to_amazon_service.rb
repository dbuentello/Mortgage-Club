module Docusign
  class UploadEnvelopeToAmazonService
    attr_reader :envelope_id, :user, :checklist, :loan, :document

    def initialize(envelope_id, checklist_id, user_id)
      @envelope_id = envelope_id
      @user = User.find(user_id)
      @checklist = Checklist.find(checklist_id)
      @loan = @checklist.loan
      @document = @checklist.document_type.constantize.new
    end

    def call
      envelope_path = Docusign::DownloadEnvelopeService.call(envelope_id)
      return false unless envelope_path && File.exist?(envelope_path)

      args = {
        subject_class_name: document.subject_name,
        document_klass_name: checklist.document_type,
        foreign_key_name: subject_key_name,
        foreign_key_id: foreign_key_id,
        current_user: user,
        params: {
          file: File.new(envelope_path),
          description: checklist.document_description
        }
      }
      DocumentServices::UploadFile.new(args).call
      File.delete(envelope_path)
      true
    end

    private

    # Ex: Closing.where(loan_id: loan.id).last.id
    def foreign_key_id
      document.subject_name.constantize.where(loan_id: loan.id).last.id
    end

    def subject_key_name
      document.subject_key_name
    end
  end
end