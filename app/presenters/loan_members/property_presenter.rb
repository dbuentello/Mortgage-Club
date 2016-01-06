class LoanMembers::PropertyPresenter
  def initialize(property)
    @property = property
  end

  def show
    @property.as_json(json_options)
  end

  private

  def json_options
    {
      include: [
        :documents
      ]
    }
  end
end
