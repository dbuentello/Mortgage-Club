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
      borrower.documents.where(is_required: true, original_filename: nil).size == 0
    end

    def co_borrower_documents_completed?
      secondary_borrower.documents.where(is_required: true, original_filename: nil).size == 0
    end
  end
end
