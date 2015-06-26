if Rails.env.development? || Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    address: 'in-v3.mailjet.com',
    port: 587,
    enable_starttls_auto: true,
    user_name: 'e29db9857b8b24c7acff5235053d6c61',
    password: '6bf5a4c3a72433b32221e37d9d409afc',
    authentication: 'plain'
  }

  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.default charset: "utf-8"
end
