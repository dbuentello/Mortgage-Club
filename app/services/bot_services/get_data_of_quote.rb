module BotServices
  class GetDataOfQuote
    def self.call(sender_id, params)
      output = FacebookBotServices::GetInfoOfQuotes.call(params)
      if output[:status_code] == 200

      else
        BotServices::FacebookService.text_message(output[:data])
      end
    end
  end
end
