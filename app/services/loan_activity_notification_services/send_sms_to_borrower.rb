require "plivo"

module LoanActivityNotificationServices
  class SendSmsToBorrower
    include Plivo

    AUTH_ID = ENV["PLIVO_AUTH_ID"]
    AUTH_TOKEN = ENV["PLIVO_AUTH_TOKEN"]
    PLIVO_SENDER = ENV["PLIVO_SENDER"]

    def self.call(loan_activity)
      activity_type = loan_activity.activity_type

      if activity_type.notify_borrower_text
        borrower_number = "1#{loan_activity.loan.borrower.phone.gsub(/\D/, '')}"
        plivo = RestAPI.new(AUTH_ID, AUTH_TOKEN)

        # Send SMS
        params = {
          "src" => PLIVO_SENDER, # Sender's phone number with country code
          "dst" => borrower_number, # Receiver's phone Number with country code
          "text" => activity_type.notify_borrower_text_body
        }

        plivo.send_message(params)
      end
    end
  end
end
