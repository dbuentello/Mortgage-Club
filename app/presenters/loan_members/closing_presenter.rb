class LoanMembers::ClosingPresenter
  def initialize(closing)
    @closing = closing
  end

  def show
    @closing.as_json(json_options)
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
