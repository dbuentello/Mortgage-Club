class PropertyPresenter
  def initialize(property)
    @property = property
  end

  def show
    @property.as_json(show_property_json_options)
  end

  def show_documents
    @property.property_documents.includes(:owner).as_json(property_documents_json_options)
  end

  private

  def property_documents_json_options
    {
      methods: [ :file_icon_url, :class_name, :owner_name ]
    }
  end

  def show_property_json_options
    {
      include: [
        :appraisal_report, :flood_zone_certification, :homeowners_insurance,
        :inspection_report, :lease_agreement, :mortgage_statement,
        :purchase_agreement, :risk_report, :termite_report, :title_report
      ]
    }
  end

end