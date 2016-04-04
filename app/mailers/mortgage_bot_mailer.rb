class MortgageBotMailer < ActionMailer::Base
  default from: ENV['EMAIL_SENDER']

  def inform_sign_up_information(sign_up_info)
    @sign_up_info = sign_up_info
    mail(
      to: ENV["MORTGAGE_BOT_INFO_RECEIVER"],
      subject: "A new user wants to apply for a mortgage"
    )
  end

  def inform_rate_information(rate_info)
    @rate_information = rate_information
    @user_email = user_email
    @user_name = user_name
    mail(
      to: ENV["MORTGAGE_BOT_INFO_RECEIVER"],
      subject: "Rate Alert Information from Our Mortgage Bot!"
    )
  end
end
