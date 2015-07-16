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

      # Request to get the template recipient info
      tabs = {}
      begin
        # get template tabs values from redis server: https://github.com/redis/redis-rb/blob/master/README.md#storing-objects
        tabs = $redis.get(options[:template_name])

        if tabs.nil?
          tabs = get_envelope_recipients_and_tabs(options[:template_id])
          tabs = tabs["signers"][0]["tabs"]

          # store tabs into redis
          $redis.set(options[:template_name], tabs.to_json)

          # Expire the cache, every 3 hours
          $redis.expire(options[:template_name], 3.hour.to_i)
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
            y_position: hash["yPosition"]
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
          if options[:values] && options[:values][tab[:name]]
            option_value = options[:values][tab[:name]]

            if option_value.is_a? Hash
              # if special case, we also set width and height
              if option_value[:width] && option_value[:height]
                # need to set both width and height if you want bug free
                tab[:width]  = option_value[:width]
                tab[:height] = option_value[:height]
              end

              tab[:value]  = option_value[:value]
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

# Tabs example:
# {
#   "signers" => [
#     {
#       "tabs" => {
#         "signHereTabs" => [
#           {
#             "name"=>"Signature", "tabLabel"=>"Signature 1", "scaleValue"=>1.0, "optional"=>"false", "documentId"=>"93881593", "recipientId"=>"91649777", "pageNumber"=>"1", "xPosition"=>"222", "yPosition"=>"86", "tabId"=>"f16770c3-c804-4cf0-9a7c-756e758345c5"
#           }
#         ],
#         "fullNameTabs" => [
#           {
#             "name"=>"Full Name", "tabLabel"=>"FullName", "font"=>"arial", "bold"=>"false", "italic"=>"false", "underline"=>"false", "fontColor"=>"black", "fontSize"=>"size9", "documentId"=>"93881593", "recipientId"=>"91649777", "pageNumber"=>"1", "xPosition"=>"104", "yPosition"=>"167", "tabId"=>"259fd706-6704-4356-9422-305b3ea56b28"
#           }
#         ],
#         "dateSignedTabs" => [
#           {
#             "name"=>"Date Signed", "value"=>"", "tabLabel"=>"Date Signed", "font"=>"arial", "bold"=>"false", "italic"=>"false", "underline"=>"false", "fontColor"=>"black", "fontSize"=>"size9", "documentId"=>"93881593", "recipientId"=>"91649777", "pageNumber"=>"1", "xPosition"=>"108", "yPosition"=>"110", "tabId"=>"424e0467-bb19-499a-953f-713cce70c5c2"
#           }
#         ],
#         "textTabs" => [
#           {
#             "height"=>22, "isPaymentAmount"=>"false", "validationPattern"=>"", "shared"=>"false", "requireInitialOnSharedChange"=>"false", "requireAll"=>"false", "name"=>"Your phone number", "value"=>"", "width"=>120, "required"=>"true", "locked"=>"false", "concealValueOnDocument"=>"false", "disableAutoSize"=>"false", "tabLabel"=>"Phone", "font"=>"arial", "bold"=>"false", "italic"=>"false", "underline"=>"false", "fontColor"=>"black", "fontSize"=>"size9", "documentId"=>"93881593", "recipientId"=>"91649777", "pageNumber"=>"1", "xPosition"=>"223", "yPosition"=>"165", "tabId"=>"d8564be7-a778-4e49-9eee-85bf9a3d4be9"
#           }
#         ]
#       },
#       "isBulkRecipient"=>"false", "name"=>"Le Hoang", "email"=>"lehoang1417@gmail.com",
#       "recipientId"=>"91649777", "recipientIdGuid"=>"2a979444-a2b1-4fcf-8a12-6fe7d1c4c73d",
#       "requireIdLookup"=>"false", "userId"=>"c98e6381-d9b5-4e86-aac4-71525477817a",
#       "routingOrder"=>"1", "note"=>"", "status"=>"created", "totalTabCount"=>"4"
#     }
#   ],
#   "agents"=>[], "editors"=>[], "intermediaries"=>[], "carbonCopies"=>[], "certifiedDeliveries"=>[], "inPersonSigners"=>[], "recipientCount"=>"1"
# }
