class Admins::HomepageFaqTypesPresenter
  def initialize(homepage_faq_types)
    @homepage_faq_types = homepage_faq_types
  end

  def show
    @homepage_faq_types.as_json(json_options)
  end

  private

  def json_options
    {
    }
  end
end
