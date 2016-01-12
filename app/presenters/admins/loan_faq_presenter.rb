class Admins::LoanFaqPresenter
  def initialize(faq)
    @faq = faq
  end

  def show
    @faq.as_json(json_options)
  end

  private

  def json_options
    {
      only: [ :id, :question, :answer ]
    }
  end
end
