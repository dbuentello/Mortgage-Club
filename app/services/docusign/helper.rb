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
      recipients = @client.get_envelope_recipients(envelope_id: envelope_id, include_tabs: true)
    end

    # GET list of tabs from template name to apply
    # PARAMS: template_id / template_name
    def get_tabs_from_template(options = {}, document_id = 1)
      # Request to get the template recipient info
      tabs = {}
      begin
        # get template tabs data from redis server: https://github.com/redis/redis-rb/blob/master/README.md#storing-objects
        tabs = REDIS.get(options[:template_name])

        if tabs.nil?
          tabs = get_envelope_recipients_and_tabs(options[:template_id])
          tabs = tabs["signers"][0]["tabs"]

          # store tabs into redis
          REDIS.set(options[:template_name], tabs.to_json)

          # Expire the cache, every 3 hours
          REDIS.expire(options[:template_name], 3.hour.to_i)
        else
          tabs = JSON.parse tabs
        end

      rescue Exception => e
        # whatever the error is, we must return api results :-)
        tabs = get_envelope_recipients_and_tabs(options[:template_id])
        tabs = tabs["signers"][0]["tabs"]

        Rails.logger.error(e)
      end

      # convert javascript tabs to ruby tabs
      ruby_tabs = {}
      tabs.each do |key, array_of_hash|
        ruby_array_of_hash = []
        array_of_hash.each do |hash|
          tab = {
            name: hash["name"],
            page_number: hash["pageNumber"],
            x_position: hash["xPosition"],
            y_position: hash["yPosition"],
            document_id: document_id
          }

          # automatically copy attributes from Docusign template
          tab[:optional]   = hash["optional"] if hash["optional"]
          tab[:tabLabel]   = hash["label"] if hash["label"]
          tab[:fontSize]   = hash["fontSize"] if hash["fontSize"]
          tab[:fontColor]  = hash["fontColor"] if hash["fontColor"]
          tab[:bold]       = hash["bold"] if hash["bold"]
          tab[:italic]     = hash["italic"] if hash["italic"]
          tab[:underline]  = hash["underline"] if hash["underline"]
          tab[:locked]     = hash["locked"] if hash["locked"]
          tab[:required]   = hash["required"] if hash["required"]

          # map value to tab
          if options[:data] && options[:data][tab[:name]]
            option_value = options[:data][tab[:name]]

            if option_value.is_a? Hash
              # if special case, we also set width and height
              if option_value[:width] && option_value[:height]
                tab[:width]  = option_value[:width]
                tab[:height] = option_value[:height]
              end

              tab[:value] = option_value[:value]
            else
              tab[:value] = option_value
            end
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

    # Destroy all envelopes that are removed from Docusign but sitll exist in our database
    # This task should be scheduled and has optional trigger button
    def clean_removed_envelopes_from_database
      envelopes = self.get_envelopes(types: ["sent"])

      database_envelopes = Envelope.all
      database_envelopes.each do |e|
        is_existing = envelopes.find { |a| a["envelopeId"] == e.docusign_id }

        unless is_existing
          e.destroy
        end
      end
    end

  end
end
