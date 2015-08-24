class BorrowerPresenter
  def initialize(borrower)
    @borrower = borrower
  end

  def show
    @borrower.as_json(show_borrower_json_options)
  end

  def show_documents
    @borrower.as_json(borrower_documents_json_options)
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
      include: {
        borrower_documents: {
          methods: [ :file_icon_url, :class_name, :owner_name ]
        }
      }
    }
  end

end