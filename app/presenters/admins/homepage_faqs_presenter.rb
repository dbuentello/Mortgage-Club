class Admins::HomepageFaqsPresenter
  def initialize(homepage_faqs)
    @homepage_faqs = homepage_faqs
  end

  def show
    @homepage_faqs.as_json(json_options)
  end

  private

  def json_options
    {
    }
  end
end
