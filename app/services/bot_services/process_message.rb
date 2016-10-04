module BotServices
  class ProcessMessage
    attr_accessor :params, :api_ai
    DEFAULT_TIMEOUT = ENV["DEFAULT_TIMEOUT"]

    def initialize(params)
      @params = params
      @api_ai = ApiAiRuby::Client.new(client_access_token: ENV["APIAI_ACCESS_TOKEN"])
    end

    def call
      messaging = params["entry"][0]["messaging"]

      if messaging && messaging[0]["sender"]
        sender_id = messaging[0]["sender"]["id"]

        if messaging[0]["message"] && messaging[0]["message"]["text"]
          text = messaging[0]["message"]["text"]
        elsif messaging[0]["postback"] && messaging[0]["postback"]["payload"]
          text = messaging[0]["postback"]["payload"]
        end

        if text
          unless BotServices::ManageFacebookSession.get_session sender_id
            uuid = SecureRandom.base64
            profile = JSON.parse(BotServices::FacebookService.get_user_profile(sender_id))
            profile["facebook_id"] = sender_id

            value = {
              "uuid" => uuid,
              "ask_credit" => false,
              "ask_downpayment": false,
              "timeout": (Time.now + DEFAULT_TIMEOUT.to_i).to_s,
              "context" => {
                "conversation_id" => uuid,
                "profile" => profile,
                "parameters" => {},
                "resolved_queries" => []
              }
            }

            BotServices::ManageFacebookSession.set_session sender_id, value
          end
        end
      end
    end
  end
end
