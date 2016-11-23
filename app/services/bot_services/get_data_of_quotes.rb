module BotServices
  class GetDataOfQuotes
    def self.call(sender_id, params)
      output = FacebookBotServices::GetInfoOfQuotes.call(params)
      if output[:status_code] == 200
        message = {
          attachment: {
            type: "template",
            payload: {
              template_type: "generic",
              elements: []
            }
          }
        }

        output[:data].each do |data|
          message[:attachment][:payload][:elements] << {
            title: data[:title],
            image_url: data[:img_url],
            subtitle: data[:subtitle],
            buttons: [{
              type: "web_url",
              url: data[:url],
              title: "Get this rate"
            }]
          }
        end
        BotServices::FacebookService.send_message(sender_id, message)
      else
        BotServices::FacebookService.send_message(sender_id, BotServices::FacebookService.text_message(output[:data]))
      end
    end
  end
end
