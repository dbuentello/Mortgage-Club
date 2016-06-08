module Docusign
  #
  # Class DownloadDocumentService provides downloading an envelope from Docusign.
  # envelope is a Docusign's term. One envelope is a document which was signed.
  #
  #
  #
  class DownloadDocumentService
    def self.call(envelope_id, filename, document_id)
      path_to_file = "#{Rails.root}/tmp/#{filename}.pdf"
      client = DocusignRest::Client.new
      result = client.get_document_from_envelope(
        envelope_id: envelope_id,
        document_id: document_id,
        local_save_path: path_to_file
      )
      return path_to_file if result && File.exist?(path_to_file)
    end
  end
end
