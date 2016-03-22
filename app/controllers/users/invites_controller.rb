class Users::InvitesController < Users::BaseController
  def create
    invite_counter = 0
    i = 0
    emails = params[:invite][:email]
    emails.each do |email|
      name = params[:invite][:name][i]
      phone = params[:invite][:phone][i]
      invite = Invite.new(email: email, name: name, phone: phone)
      invite.sender_id = current_user.id

      if invite.save && invite.recipient.nil?
        InviteMailer.new_user_invite(current_user, invite).deliver_later
        invite_counter += 1
      end
      i += 1
    end
    invites = Invite.where(sender_id: current_user.id).order(created_at: :desc)

    if invite_counter > 0
      render json: {
        success: true,
        invites: LoanListPage::InvitesPresenter.new(invites).show,
        message: t("invites.create.success", invite_counter: invite_counter)
      }
    else
      render json: {success: false, message: t("invites.create.failed")}
    end
  end
end
