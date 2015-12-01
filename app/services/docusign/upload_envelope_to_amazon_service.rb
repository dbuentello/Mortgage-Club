module Docusign
  class UploadEnvelopeToAmazonService
    attr_reader :envelope_id, :user, :checklist, :loan

    def initialize(envelope_id, checklist_id, user_id)
      @envelope_id = envelope_id
      @user = User.find(user_id)
      @checklist = Checklist.find(checklist_id)
      @loan = @checklist.loan
    end

    def call
      envelope_path = Docusign::DownloadEnvelopeService.call(envelope_id)
      return false unless envelope_path && File.exist?(envelope_path)

      args = {
        subject_type: checklist.subject_name,
        subject_id: checklist.subject_id,
        document_type: checklist.document_type,
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
  end
end
