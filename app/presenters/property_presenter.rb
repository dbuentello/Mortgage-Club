class PropertyPresenter
  def initialize(property)
    @property = property
  end

  def show
    Rails.cache.fetch("property_presenter_show-#{@property.id}-#{@property.updated_at.to_i}", expires_in: 7.day) do
      @property.as_json(show_property_json_options)
    end
  end

  def show_documents
    Rails.cache.fetch("property_presenter_show_documents-#{@property.id}-#{@property.updated_at.to_i}", expires_in: 7.day) do
      @property.property_documents.includes(:owner).as_json(property_documents_json_options)
    end
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