class InviteMailer < ActionMailer::Base
  default :from => ENV['EMAIL_SENDER']

  def new_user_invite(sender, invite)
    @sender = sender
    @invite = invite

    mail(
      to: invite.email,
      subject: "#{sender} has invited you to join Mortgage Club"
    )
  end

end