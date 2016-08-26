class Admins::LoanActivityNamesPresenter
  def initialize(activity_names)
    @activity_names = activity_names
  end

  def show
    @activity_names.as_json(json_options)
  end

  private

  def json_options
    {
      include: {
        activity_type: {
          only: [:label]
        }
      }
    }
  end
end
