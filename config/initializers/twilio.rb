if Rails.env.development? || Rails.env.production?
  Twilio.configure do |config|
    config.account_sid = ENV['TWILIO_ACCOUNT_SID']
    config.auth_token = ENV['TWILIO_AUTH_TOKEN']
  end
elsif Rails.env.test?
  Twilio.configure do |config|
    config.account_sid = 'ACb2ad33737112c1582f87f74423cdf0c3'
    config.auth_token = 'ea69500052a5d39c4bb29a7eed5febff'
  end
end
