class Admins::DocusignTemplatePresenter
  def initialize(docusign_template)
    @docusign_template = docusign_template
  end

  def show
    @docusign_template.as_json(json_options)
  end

  private

  def json_options
    {

    }
  end
end
