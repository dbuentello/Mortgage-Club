class InviteService
  def self.update(token, invite_code, user)
    # Update invite join_at
    if token.present?
      invite = Invite.find_by_token(token)
      invite.join_at = Time.zone.now
      invite.save
    else
      if invite_code.present?
        invite = Invite.new(email: user.email, name: user.to_s)
        invite.sender_id = invite_code
        invite.join_at = Time.zone.now
        invite.save
      end
    end
  end
end