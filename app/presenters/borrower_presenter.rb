class BorrowerPresenter
  def initialize(borrower)
    @borrower = borrower
  end

  def show
    Rails.cache.fetch("borrower_presenter_show-#{@borrower.id}-#{@borrower.updated_at.to_i}", expires_in: 7.day) do
      @borrower.as_json(show_borrower_json_options)
    end
  end

  def show_documents
    Rails.cache.fetch("borrower_presenter_show_documents-#{@borrower.id}-#{@borrower.updated_at.to_i}", expires_in: 7.day) do
      @borrower.borrower_documents.includes(:owner).as_json(borrower_documents_json_options)
    end
  end

  private

  def show_borrower_json_options
    {
      include: [
        user: {
          only: [ :email ]
        }
      ],
      methods: [
        :current_address, :previous_addresses, :current_employment, :previous_employments,
        :first_name, :last_name, :middle_name, :suffix
      ]
    }
  end

  def borrower_documents_json_options
    {
      methods: [ :file_icon_url, :class_name, :owner_name ]
    }
  end

end