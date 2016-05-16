class NewUserMailer < ActionMailer::Base
  default from: ENV["EMAIL_SENDER"]

  def inform_sign_up_information(sign_up_info)
    @sign_up_info = sign_up_info
    email_setting = Setting.where(name: "Email For Notification About New User To Admin").first

    mail(
      to: email_setting.nil? ? ENV["EMAIL_RECEIVER"] : email_setting[:value],
      subject: "#{sign_up_info[:first_name]} #{sign_up_info[:last_name]} has signed up for MortgageClub"
    )
  end
end
