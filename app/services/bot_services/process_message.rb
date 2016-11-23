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
          array = speech_text.split("|");
          ap response
          case array[0]
          when BotServices::ApiAiCode.welcome
            text = array[1].insert(5, " #{user_session[:context][:profile]['first_name']}")
            content = replies_message(text, BotServices::FacebookButtons.btn_welcome)
          when BotServices::ApiAiCode.purpose
            content = replies_message(array[1], BotServices::FacebookButtons.btn_purpose_types)
          when BotServices::ApiAiCode.down_payment
            user_session[:ask_downpayment] = true
            BotServices::ManageFacebookSession.set_session(sender_id, user_session)
            content = text_message(array[1])
          when BotServices::ApiAiCode.usage
            content = replies_message(array[1], BotServices::FacebookButtons.btn_usage)
          when BotServices::ApiAiCode.credit_score
            content = replies_message(array[1], BotServices::FacebookButtons.btn_credit_score)
          when BotServices::ApiAiCode.end_conversation
            content = text_message(array[1])
            FacebookPostResultJob.perform_later(sender_id, response[:result][:parameters])
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


    # apiaiRequest.on('response', (response) => {
    #   # // console.log("Response API AI ========== ");
    #   # // console.log(response);

    #   setUpTimeout(sender, sessionIds.get(sender).context);
    #   if (utils.isDefined(response.result)) {

    #     let responseText = response.result.fulfillment.speech;
    #     let source = response.result.fulfillment.source;
    #     let action = response.result.action;
    #     sessionIds.get(sender).context.parameters = response.result.parameters;
    #     sessionIds.get(sender).context.resolved_queries.push({
    #       "question": responseText,
    #       "answer": response.result.resolvedQuery,
    #       "timestamp": response.timestamp
    #     });

    #     if (utils.isDefined(responseText)) {
    #       # // console.log(sessionIds.get(sender));
    #
    #       # // console.log("Code :====== " + arvar arr = responseText.split("|");r[0]);
    #       # // console.log("Mess :====== " + arr[1]);
    #       if (isNaN(arr[0])) {
    #         # // console.log('This is not number');
    #           fbServices.sendFBMessage(sender, fbServices.textMessage(arr[0]));
    #           return;

    #       } else {

    #         if(arr[0] == API_AI_CODE.address) {
    #           if (utils.isDefined(response.result.parameters.address)) {
    #             console.log("data before Geo api ai: " + response.result.parameters.address);
    #             googleGeo.addressValidator(response.result.parameters.address, function(data) {
    #               if (utils.isDefined(data)) {
    #                 # // console.log("address after validator");
    #                 # // console.log(data);
    #                 addressQueue.set(Date.now().toString(), {
    #                   data: data,
    #                   facebook_id: sender,
    #                   refinance_api: false
    #                 });
    #                 fbServices.sendFBMessage(sender, fbServices.textMessage(waitingAddress));
    #                 console.log("set address ok");
    #                 console.log(addressQueue);
    #                 return;
    #               } else {
    #                 fbServices.sendFBMessage(sender, fbServices.textMessage(addressNotFoundStr));
    #                 return;
    #               }
    #             });
    #           }
    #           return;
    #         }

    #         if (arr[0] == API_AI_CODE.welcome) {

    #           setTimeout(function() {
    #             if (sessionIds.get(sender)) {
    #               arr[1] = arr[1].slice(0, 5) + " " + sessionIds.get(sender).context.profile.first_name + arr[1].slice(5);
    #               fbServices.sendFBMessage(sender, fbServices.buttonMessage(arr[1], mapFbBtn.get(arr[0])));
    #             }
    #           }, 2000);
    #           return;
    #         }
    #         if (arr[0] == API_AI_CODE.purpose) {
    #           fbServices.sendFBMessage(sender, fbServices.buttonMessage(arr[1], mapFbBtn.get(arr[0])));
    #           return;
    #         }
    #         if (arr[0] == API_AI_CODE.downpayment) {
    #           sessionIds.get(sender).ask_downpayment = true;
    #           fbServices.sendFBMessage(sender, fbServices.textMessage(arr[1]));
    #           return;
    #         }

    #         if (arr[0] == API_AI_CODE.creditScoreCode) {
    #           sessionIds.get(sender).ask_credit = true;
    #           fbServices.sendFBMessage(sender, fbServices.textMessage(arr[1]));
    #           return;
    #         }

    #         if (arr[0] == API_AI_CODE.endApiAiConversation) {
    #           fbServices.sendFBMessage(sender, fbServices.textMessage(arr[1]));
    #           mcServices.getQuotes(sender, response.result, function(err){
    #             if(err){
    #               console.log("err when get quotes");
    #             }
    #           });
    #           return;
    #         }

    #         fbServices.sendFBMessage(sender, fbServices.buttonMessage(arr[1], mapFbBtn.get(arr[0])));
    #         return;
    #       }
    #     }
    #   }
    # });
