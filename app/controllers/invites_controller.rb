class InvitesController < ApplicationController

  def create
    invite_counter = 0
    for i in 0...params[:invite][:email].count
      email = params[:invite][:email][i]
      name = params[:invite][:name][i]
      phone = params[:invite][:phone][i]
      invite = Invite.new(email: email, name: name, phone: phone)
      invite.sender_id = current_user.id

      if invite.save
        if invite.recipient != nil
          # the user already exists
        else
          InviteMailer.delay.new_user_invite(current_user, invite)
          invite_counter += 1
        end
      end
    end

    if invite_counter > 0
      render json: {success: true, message: "#{invite_counter} person was successfully invited to Mortgage Club!"}
    else
      render json: {success: false, message: "Error, the email is already invited or not valid!"}
    end
  end

end