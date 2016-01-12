class LoanDashboardPage::FaqsPresenter
  def initialize(faqs)
    @faqs = faqs
  end

  def show
    @faqs.as_json(json_options)
  end

  private

  def json_options
    {
      only: [ :id, :question, :answer ]
    }
  end
end
