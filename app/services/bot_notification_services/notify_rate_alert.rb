# send email to Billy to notify that user wants to sign up for rate alert.
module BotNotificationServices
  class NotifyRateAlert
    extend ParseData

    def self.call(params)
      if data = parsed_data(params)
        MortgageBotMailer.inform_rate_information(data).deliver_later
      end
      "Awesome, we'll notify you when rates drop. Goodbye!"
    end
  end
end
