class LoanMembers::BorrowerDocumentsPresenter
  def initialize(documents)
    @documents = documents
  end

  def show
    @documents.as_json(json_options)
  end

  private

  def json_options
    {

    }
  end
end
