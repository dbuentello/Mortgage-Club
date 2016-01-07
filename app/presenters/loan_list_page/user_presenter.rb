class LoanListPage::UserPresenter
  def initialize(user)
    @user = user
  end

  def show
    @user.as_json(json_options)
  end

  private

  def json_options
    {
      only: [:id, :to_s, :avatar_url, :role_name, :email],
      methods: [:avatar_url]
    }
  end
end
