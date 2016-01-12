class Admins::LoanActivityTypePresenter
  def initialize(activity_type)
    @activity_type = activity_type
  end

  def show
    @activity_type.as_json(json_options)
  end

  private

  def json_options
    {
      only: [ :id, :type, :type_name_mapping ]
    }
  end
end
