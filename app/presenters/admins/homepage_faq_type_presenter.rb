class Admins::HomepageFaqTypePresenter
  def initialize(homepage_faq_type)
    @homepage_faq_type = homepage_faq_type
  end

  def show
    @homepage_faq_type.as_json(json_options)
  end

  private

  def json_options
    {
    }
  end
end
