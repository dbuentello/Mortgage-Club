class LenderTemplatesPresenter
  def self.index(lenders)
    lenders.as_json(lender_template_json_options)
  end

  def self.show(lender)
    lender.as_json(lender_template_json_options)
  end

  private

  def self.lender_template_json_options
    {
      only: [:id, :name, :description, :is_other]
    }
  end
end
