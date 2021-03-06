class LoanMembers::BorrowerPresenter
  def initialize(borrower)
    @borrower = borrower
  end

  def show
    @borrower.as_json(show_borrower_json_options)
  end

  def show_documents
    @borrower.borrower_documents.includes(:owner).as_json(borrower_documents_json_options)
  end

  private

  def show_borrower_json_options
    {
      include: [
        :documents,
        user: {
          only: [:email]
        }
      ],
      methods: [
        :current_address, :previous_address, :current_employment, :previous_employment,
        :first_name, :last_name, :middle_name, :suffix, :other_documents
      ]
    }
  end

  def borrower_documents_json_options
    {
      methods: [:file_icon_url, :class_name, :owner_name]
    }
  end
end
