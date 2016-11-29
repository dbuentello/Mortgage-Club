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

        if messaging[0]["message"] && messaging[0]["message"]["quick_reply"]
          text = messaging[0]["message"]["quick_reply"]["payload"]
        elsif messaging[0]["message"] && messaging[0]["message"]["text"]
          text = messaging[0]["message"]["text"]
        elsif messaging[0]["postback"] && messaging[0]["postback"]["payload"]
          text = messaging[0]["postback"]["payload"]
        end

        if text
          unless BotServices::ManageFacebookSession.get_session(sender_id)
            uuid = SecureRandom.uuid
            profile = JSON.parse(BotServices::FacebookService.get_user_profile(sender_id))
            profile["facebook_id"] = sender_id

            value = {
              uuid: uuid,
              ask_credit: false,
              ask_downpayment: false,
              timeout: (Time.zone.now + DEFAULT_TIMEOUT.to_i.seconds).to_s,
              context: {
                conversation_id: uuid,
                profile: profile
              }
            }

            BotServices::ManageFacebookSession.set_session sender_id, value
          end

          user_session = BotServices::ManageFacebookSession.get_session(sender_id)

          api_ai.api_session_id = user_session[:uuid]
          response = api_ai.text_request text

          speech_text = response[:result][:fulfillment][:speech]
          array = speech_text.split("|")

          case array[0]
          when BotServices::ApiAiCode.welcome
            text = array[1].insert(5, " #{user_session[:context][:profile]['first_name']}")
            content = replies_message(text, BotServices::FacebookButtons.btn_welcome)
          when BotServices::ApiAiCode.purpose
            content = replies_message(array[1], BotServices::FacebookButtons.btn_purpose_types)
          when BotServices::ApiAiCode.down_payment
            content = replies_message(array[1], BotServices::FacebookButtons.btn_down_payment)
          when BotServices::ApiAiCode.usage
            content = replies_message(array[1], BotServices::FacebookButtons.btn_usage)
          when BotServices::ApiAiCode.credit_score
            content = replies_message(array[1], BotServices::FacebookButtons.btn_credit_score)
          when BotServices::ApiAiCode.end_conversation
            content = text_message(array[1])
            intent = response[:result][:metadata][:intentName]
            # ap response[:result]

            FacebookPostResultJob.perform_later(sender_id, response[:result][:parameters], intent)
          when BotServices::ApiAiCode.property_type
            content = replies_message(array[1], BotServices::FacebookButtons.btn_property_types)
          else
            content = text_message(speech_text)
          end

          send_message(sender_id, content)
          return
        end
      end
    end

    def send_message(sender_id, content)
      BotServices::FacebookService.send_message(sender_id, content)
    end

    def replies_message(text, quick_reply)
      BotServices::FacebookService.quick_replies_message(text, quick_reply)
    end

    def text_message(text)
      BotServices::FacebookService.text_message(text)
    end
  end
end
