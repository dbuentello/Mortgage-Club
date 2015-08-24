class PropertyPresenter
  def initialize(property)
    @property = property
  end

  def show_documents
    @property.as_json(property_documents_json_options)
  end

  private

  def property_documents_json_options
    {
      include: {
        property_documents: {
          methods: [ :file_icon_url, :class_name, :owner_name ]
        }
      }
    }
  end


end