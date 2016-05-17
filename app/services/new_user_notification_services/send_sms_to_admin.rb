# send sms to Billy to notify that user wants to sign up.
require "plivo"

module NewUserNotificationServices
  class SendSmsToAdmin
    include Plivo

    AUTH_ID = ENV["PLIVO_AUTH_ID"]
    AUTH_TOKEN = ENV["PLIVO_AUTH_TOKEN"]
    PLIVO_SENDER = ENV["PLIVO_SENDER"]
    BILLY_PHONE_NUMBER = ENV["BILLY_PHONE_NUMBER"]

    def self.call(params)
      plivo = RestAPI.new(AUTH_ID, AUTH_TOKEN)
      phone_setting = Setting.where(name: "Sms For Notification About New User To Admin").first

      # Send SMS
      params = {
        "src" => PLIVO_SENDER, # Sender's phone number with country code
        "dst" => phone_setting.nil? ? BILLY_PHONE_NUMBER : phone_setting[:value], # Receiver's phone Number with country code
        "text" => "A new user has signed up for MortgageClub. #{params[:first_name]} #{params[:last_name]} (#{params[:email]})"
      }

      plivo.send_message(params)
    end
  end
end
