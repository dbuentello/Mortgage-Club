class PotentialUserMailer < ActionMailer::Base
  default :from => ENV['EMAIL_SENDER']

  def inform_new_file_upload(user)

    mail(
      to: user.email,
      subject: "Thank you for your concern!"
    )
  end
end
