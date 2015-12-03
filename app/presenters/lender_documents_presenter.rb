class LenderDocumentsPresenter
  def self.index(documents)
    documents.includes(:user).as_json(document_json_options)
  end

  def self.show(document)
    document.as_json(document_json_options)
  end

  private

  def self.document_json_options
    {
      include: {
        loan: {
          only: [:id]
        },
        user: {
          methods: [:to_s, :avatar_url, :role_name]
        }
      },
    }
  end
end
