# send email to Billy to notify that user wants to sign up for rate alert.
module BotNotificationServices
  class NotifyRateAlert
    extend ParseData

    def self.call(params)
      output = {}
      if data = parsed_data(params)
        MortgageBotMailer.inform_rate_information(data, params[:source]).deliver_later
      end
      output[:data] = "Awesome, we'll notify you when rates drop. Goodbye!"
      output[:status_code] = 200
      output.to_json
    end
  end
end
