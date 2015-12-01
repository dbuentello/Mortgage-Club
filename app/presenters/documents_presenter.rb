class DocumentsPresenter
  def initialize(documents)
    @documents = documents
  end

  def show
    @documents.as_json(document_json_options)
  end

  private

  def document_json_options
    {
      include: {
        user: {
          methods: [:to_s]
        }
      },
      methods: [:file_icon_url]
    }
  end
end
