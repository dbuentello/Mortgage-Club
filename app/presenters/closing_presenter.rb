class ClosingPresenter
  def initialize(closing)
    @closing = closing
  end

  def show_documents
    @closing.as_json(closing_documents_json_options)
  end

  private

  def closing_documents_json_options
    {
      include: {
        closing_documents: {
          methods: [ :file_icon_url, :class_name ]
        }
      }
    }
  end

end