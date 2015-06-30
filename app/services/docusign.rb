require 'open-uri'

class Docusign

  def self.create_envelope_from_document(document = nil)
    document ||= Documents::FirstW2.first
    file_url = document.attachment.s3_object.url_for(:read, :secure => true, :expires => 3.minutes).to_s

    # file_url = "/Users/hoangle/projects/homieo/public/examples/sample.png"
    file_io = open(file_url)

    client = DocusignRest::Client.new
    document_envelope_response = client.create_envelope_from_document(
      email: {
        subject: "Test from Hoang",
        body: "let sign it guys"
      },
      # If embedded is set to true  in the signers array below, emails
      # don't go out to the signers and you can embed the signature page in an
      # iFrame by using the client.get_recipient_view method
      signers: [
        {
          embedded: false,
          name: 'Henry',
          email: 'henryle0306@gmail.com',
          role_name: 'Issuer'
          # sign_here_tabs: [
          #   {
          #     anchor_string: 'sign_here_1',
          #     anchor_x_offset: '140',
          #     anchor_y_offset: '8'
          #   }
          # ]
        }
      ],
      files: [
        # {path: file_url, name: 'sample.png'}
        {io: file_io, name: document.attachment.instance.attachment_file_name}
      ],
      status: 'sent'
    )

    # document_envelope_response["envelopeId"]
  end
end
