class MortgageBotMailer < ActionMailer::Base
  default from: ENV["EMAIL_SENDER"]

  def inform_sign_up_information(sign_up_info, source)
    @sign_up_info = sign_up_info
    @source = source
    mail(
      to: ENV["MORTGAGE_BOT_INFO_RECEIVER"],
      subject: "A new user wants to apply for a mortgage"
    )
  end

  def inform_rate_information(sign_up_info, source)
    @sign_up_info = sign_up_info
    @source = source
    mail(
      to: ENV["MORTGAGE_BOT_INFO_RECEIVER"],
      subject: "A new user has signed up for Rate Alert"
    )
  end
end
