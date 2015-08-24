class PropertyPresenter
  def initialize(property)
    @property = property
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


end