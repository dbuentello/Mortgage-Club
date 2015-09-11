class InviteService
  def self.call(token, invite_code, user)
    # Update invite join_at
    if token.present?
      invite = Invite.find_by_token(token)
      invite.join_at = Time.zone.now
      invite.recipient_id = user.id
      invite.status = 'done'
      invite.save
    else
      if invite_code.present?
        Invite.create(email: user.email, name: user.to_s, status: 'done', sender_id: invite_code, recipient_id: user.id, join_at: Time.zone.now)
      end
    end
  end
end