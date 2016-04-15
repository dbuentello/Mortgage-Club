module CompletedLoanServices
  class TabDocuments
    # Co-Borrower Except Documents
    CO_EXCEPT_DOCS = ["first_bank_statement", "second_bank_statement"]
    attr_accessor :borrower, :secondary_borrower

    def initialize(args)
      @borrower = args[:borrower]
      @secondary_borrower = args[:secondary_borrower]
    end

    def call
      return borrower_documents_completed? unless secondary_borrower.present?
      borrower_documents_completed? && co_borrower_documents_completed?
    end

    def borrower_documents_completed?
      not_jointly_document_completed?(borrower)
    end

    def co_borrower_documents_completed?
      borrower.is_file_taxes_jointly ? secondary_jointly_document_completed? : secondary_not_jointly_document_completed?(secondary_borrower)
    end

    def secondary_jointly_document_completed?
      byebug
      required_documents = secondary_borrower.self_employed ? (Document::BORROWER_SELF_EMPLOYED_TAXES_JOINLY - CO_EXCEPT_DOCS)  : (Document::BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY - CO_EXCEPT_DOCS)

      (required_documents - secondary_borrower.documents.pluck(:document_type)).empty?
    end

    def not_jointly_document_completed?(not_jointly_borrower)

      required_documents = not_jointly_borrower.self_employed ? Document::BORROWER_SELF_EMPLOYED : Document::BORROWER_NOT_SELF_EMPLOYED

      (required_documents - not_jointly_borrower.documents.pluck(:document_type)).empty?
    end

    def secondary_not_jointly_document_completed?(co_not_jointly_borrower)
      required_documents = co_not_jointly_borrower.self_employed ? Document::BORROWER_SELF_EMPLOYED - CO_EXCEPT_DOCS : Document::BORROWER_NOT_SELF_EMPLOYED - CO_EXCEPT_DOCS

      (required_documents - co_not_jointly_borrower.documents.pluck(:document_type)).empty?
    end
  end
end
