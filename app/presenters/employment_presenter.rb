class EmploymentPresenter
  def initialize(employment)
    @employment = employment
  end

  def show
    @employment.as_json(show_employment_json_options)
  end

  private

  def show_employment_json_options
    {
      include: [
        :address
      ]
    }
  end
end
