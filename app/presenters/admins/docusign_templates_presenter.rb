class Admins::DocusignTemplatesPresenter
  def initialize(docusign_templates)
    @docusign_templates = docusign_templates
  end

  def show
    @docusign_templates.as_json(json_options)
  end

  private

  def json_options
    {

    }
  end
end
