class TemplatesPresenter
  def self.index(templates)
    templates.as_json(template_json_options)
  end

  def self.show(template)
    template.as_json(template_json_options)
  end

  private

  def self.template_json_options
    {}
  end
end
