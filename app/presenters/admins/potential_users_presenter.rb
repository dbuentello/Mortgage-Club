class Admins::PotentialUsersPresenter
  def initialize(potential_users)
    @potential_users = potential_users
  end

  def show
    @potential_users.as_json(json_options)
  end

  private

  def json_options
    {
      only: [:id, :email, :phone_number, :mortgage_statement_file_name],
      methods: [:url]
    }
  end
end
