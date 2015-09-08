class InvitesPresenter
  def self.index(invites)
    invites.as_json(invite_json_options)
  end

  private

  def self.invite_json_options
    {
      only: [:id, :email, :name, :phone, :sender_id, :recipient_id]
    }
  end
end
