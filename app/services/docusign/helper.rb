module Docusign
  class Helper
    def initialize(args = {})
      @client = args[:client] || DocusignRest::Client.new
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

    # GET list of tabs from template name to apply
    # PARAMS: template_id / template_name
    def get_tabs_from_template(options = {})
      if options[:template_id].blank?
        options[:template_id] = find_template_id_from_name(options[:template_name])
      end

      # request to get the template recipient info
      tabs = get_envelope_recipients_and_tabs(options[:template_id])
      tabs = tabs["signers"][0]["tabs"]

      # convert javascript tabs to ruby tabs
      ruby_tabs = {}
      tabs.each do |key, array_of_hash|
        ruby_array_of_hash = []
        array_of_hash.each do |hash|
          tab = {
            name: hash["name"],
            page_number: hash["pageNumber"],
            x_position: hash["xPosition"],
            y_position: hash["yPosition"]
          }

          tab[:optional]   = hash["optional"] if hash["optional"]
          tab[:tabLabel]   = hash["label"] if hash["label"]
          tab[:width]      = hash["width"] if hash["width"]
          tab[:height]     = hash["height"] if hash["height"]
          tab[:fontSize]   = hash["fontSize"] if hash["fontSize"]
          tab[:fontColor]  = hash["fontColor"] if hash["fontColor"]
          tab[:bold]       = hash["bold"] if hash["bold"]
          tab[:italic]     = hash["italic"] if hash["italic"]
          tab[:underline]  = hash["underline"] if hash["underline"]
          tab[:locked]     = hash["locked"] if hash["locked"]
          tab[:required]   = hash["required"] if hash["required"]

          # map value to tab
          if options[:values][tab[:name]]
            tab[:value]    = options[:values][tab[:name]]
          end

          ruby_array_of_hash << tab
        end

        ruby_key = key.underscore.to_sym
        ruby_tabs[ruby_key] = ruby_array_of_hash
      end

      ruby_tabs
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