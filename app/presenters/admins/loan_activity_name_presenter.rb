class Admins::LoanActivityNamePresenter
  def initialize(activity_name)
    @activity_name = activity_name
  end

  def show
    @activity_name.as_json(json_options)
  end

  private

  def json_options
    {
    }
  end
end
