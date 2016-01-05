class LoanListPage::InvitesPresenter
  def initialize(invites)
    @invites = invites
  end

  def show
    @invites.as_json(json_options)
  end

  private

  def json_options
    {
      only: [:id, :email, :name, :phone, :sender_id, :recipient_id, :join_at]
    }
  end
end
