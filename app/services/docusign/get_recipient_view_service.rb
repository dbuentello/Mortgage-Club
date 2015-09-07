require 'open-uri'

module Docusign
  class GetRecipientViewService
    # Docusign's enveloped_id
    def self.call(envelope_id, user, return_url)
      client = DocusignRest::Client.new
      client.get_recipient_view(
        envelope_id: envelope_id,
        name: user.to_s,
        email: user.email,
        return_url: return_url
      )
    end
  end
end