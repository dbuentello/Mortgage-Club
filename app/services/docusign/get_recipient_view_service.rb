require 'open-uri'

module Docusign
  class GetRecipientViewService
    # Docusign's enveloped_id
    def self.call(envelope_id, user, return_url)
      response = DocusignRest::Client.new.get_recipient_view(
        envelope_id: envelope_id,
        name: user.to_s,
        email: user.email,
        return_url: return_url
      )
      return response if response["errorCode"].nil?
    end
  end
end

#{"errorCode"=>"RECIPIENT_NOT_IN_SEQUENCE", "message"=>"The token for an out of sequence recipient cannot be generated."}