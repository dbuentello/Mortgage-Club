# unless Rails.env.test?
#   ActionMailer::Base.smtp_settings = {
#     address: 'in-v3.mailjet.com',
#     port: 587,
#     enable_starttls_auto: true,
#     user_name: ENV["MAILJET_USERNAME"],
#     password: ENV["MAILJET_PASSWORD"],
#     authentication: 'plain'
#   }

#   ActionMailer::Base.delivery_method = :smtp
#   ActionMailer::Base.default charset: "utf-8"
# end
unless Rails.env.test?
  ActionMailer::Base.smtp_settings = {
    user_name: 'nhokjoy',
    password: 'tang14121992',
    address: 'smtp.sendgrid.net',
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }

  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.default charset: "utf-8"
end
