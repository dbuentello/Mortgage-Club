module CompletedLoanServices
  class TabDocuments
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
      required_documents = borrower.self_employed ? Document::BORROWER_SELF_EMPLOYED : Document::BORROWER_NOT_SELF_EMPLOYED

      (required_documents - borrower.documents.pluck(:document_type)).empty?
    end

    def co_borrower_documents_completed?
      borrower.self_employed ? docoments_self_employed_completed? : docoments_not_self_employed_completed?
    end

    def docoments_self_employed_completed?
      required_documents = borrower.is_file_taxes_jointly ? Document::BORROWER_SELF_EMPLOYED_TAXES_JOINLY : Document::BORROWER_SELF_EMPLOYED

      (required_documents - borrower.documents.pluck(:document_type)).empty?
    end

    def docoments_not_self_employed_completed?
      required_documents = borrower.is_file_taxes_jointly ? Document::BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY : Document::BORROWER_NOT_SELF_EMPLOYED

      (required_documents - borrower.documents.pluck(:document_type)).empty?
    end
  end
end
