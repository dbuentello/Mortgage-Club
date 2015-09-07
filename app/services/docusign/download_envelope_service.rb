module Docusign
  class DownloadEnvelopeService
    def self.call(envelope_id)
      path_to_file = "#{Rails.root}/tmp/temp_envelope_#{envelope_id}.pdf"
      client = DocusignRest::Client.new
      client.get_combined_document_from_envelope(
        envelope_id: envelope_id,
        return_stream: false,
        local_save_path: path_to_file
      )

      return path_to_file if File.exist?(path_to_file)
    end
  end
end