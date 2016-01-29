class Admins::PotentialUserPresenter
  def initialize(potential_user)
    @potential_user = potential_user
  end

  def show
    @potential_user.as_json(json_options)
  end

  private

  def json_options
    {
      only: [ :id, :email, :phone_number],
      include: {
        mortgage_statement: {
          only: [ :id ]
        }
      }
    }
  end
end
