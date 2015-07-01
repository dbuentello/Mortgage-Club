module Docusign
  class Helper
    def initialize(args = nil)
      @client = DocusignRest::Client.new
    end

    # GET template_id
    def find_template_id_from_name(template_name)
      templates = @client.get_templates
      template = templates["envelopeTemplates"].find { |a| a["name"] == template_name }

      template["templateId"]
    end

    # GET tabs from default recipient of either an envelope or a template
    def get_envelope_recipients_and_tabs(envelope_id)
      envelope_id ||= '1779f86b-6070-40be-bb6c-cfec9cd579f1'
      recipients = @client.get_envelope_recipients(envelope_id: envelope_id, include_tabs: true)
    end

    # GET list of tabs from template name
    def get_tabs_from_template_name(template_name)
      template_id = find_template_id_from_name(template_name)

      tabs = get_envelope_recipients_and_tabs(template_id)

      ap tabs["signers"][0]["tabs"]
    end

    # GET list of envelope objects
    def get_envelopes(options = {})
      options[:from_date] ||= 1.month.ago
      options[:types] ||= ["completed", "sent"]

      envelopes = @client.get_envelope_statuses(from_date: options[:from_date].to_datetime)
      envelopes = envelopes["envelopes"].select { |x| options[:types].include?(x["status"]) }
    end

  end
end