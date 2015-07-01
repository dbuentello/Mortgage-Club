module Docusign
  class Helper
    def initialize(args = nil)
      @client = DocusignRest::Client.new
    end

    # GET template_id
    def find_template_id_from_name(template_name)
      templates = @client.get_templates
      template = templates["envelopeTemplates"].find { |a| a["name"] == template_name }

      return template["templateId"]
    end

    # GET envelope_object
    def get_envelopes(types: nil, from_date: nil)
      from_date ||= 1.month.ago
      types ||= ["completed", "sent"]

      envelopes = @client.get_envelope_statuses(from_date: from_date.to_datetime)
      envelopes = envelopes["envelopes"].select { |x| types.include?(x["status"]) }
    end

    # GET tabs from default recipient
    def get_envelope_recipients_and_tabs(envelope_id)
      envelope_id ||= '1779f86b-6070-40be-bb6c-cfec9cd579f1'
      recipients = @client.get_envelope_recipients(envelope_id: envelope_id, include_tabs: true)
    end

  end
end