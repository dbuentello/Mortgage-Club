class Admins::HomepageFaqPresenter
  def initialize(homepage_faq)
    @homepage_faq = homepage_faq
  end

  def show
    @homepage_faq.as_json(json_options)
  end

  private

  def json_options
    {
    }
  end
end
