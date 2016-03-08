class Admins::PotentialRateDropUserPresenter
  def initialize(potential_rate_drop_user)
    @potential_rate_drop_user = potential_rate_drop_user
  end

  def show
    @potential_rate_drop_user.as_json(json_options)
  end

  private

  def json_options
    {
      only: [:id, :email, :phone_number, :zip, :current_mortgage_rate, :current_mortgage_balance, :estimated_home_value, :credit_score, :refinance_purpose]
    }
  end
end
