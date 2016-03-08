class Admins::PotentialRateDropUsersPresenter
  def initialize(potential_rate_drop_users)
    @potential_rate_drop_users = potential_rate_drop_users
  end

  def show
    @potential_rate_drop_users.as_json(json_options)
  end

  private

  def json_options
    {
      only: [:id, :email, :phone_number, :zip, :current_mortgage_rate, :current_mortgage_balance, :estimated_home_value, :credit_score, :refinance_purpose],
      methods: [:url, :alert_method]
    }
  end
end
