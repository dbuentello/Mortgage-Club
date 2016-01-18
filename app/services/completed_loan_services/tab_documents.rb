module CompletedLoanServices
  class TabDocuments
    attr_accessor :borrower, :secondary_borrower

    DOCUMENTS_BORROWER_SELF_EMPLOYED = %w(first_personal_tax_return second_personal_tax_return
                                        first_business_tax_return second_business_tax_return
                                        first_bank_statement second_bank_statement)

    DOCUMENTS_BORROWER_SELF_EMPLOYED_TAXES_JOINLY = %w(first_business_tax_return second_business_tax_return
                                                          first_bank_statement second_bank_statement)

    DOCUMENTS_BORROWER_NOT_SELF_EMPLOYED = %w(first_w2 second_w2 first_paystub second_paystub
                                            first_federal_tax_return second_federal_tax_return
                                            first_bank_statement second_bank_statement)

    DOCUMENTS_BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY = %w(first_w2 second_w2 first_paystub second_paystub
                                                          first_bank_statement second_bank_statement)

    def initialize(args)
      @borrower = args[:borrower]
      @secondary_borrower = args[:secondary_borrower]
    end

    def call
      return borrower_documents_completed? unless secondary_borrower.present?
      borrower_documents_completed? && co_borrower_documents_completed?
    end

    def borrower_documents_completed?
      required_documents = borrower.self_employed ? DOCUMENTS_BORROWER_SELF_EMPLOYED : DOCUMENTS_BORROWER_NOT_SELF_EMPLOYED

      (required_documents - borrower.documents.pluck(:document_type)).empty?
    end

    def co_borrower_documents_completed?
      borrower.self_employed ? docoments_self_employed_completed? : docoments_not_self_employed_completed?
    end

    def docoments_self_employed_completed?
      required_documents = borrower.is_file_taxes_jointly ? DOCUMENTS_BORROWER_SELF_EMPLOYED_TAXES_JOINLY : DOCUMENTS_BORROWER_SELF_EMPLOYED

      (required_documents - borrower.documents.pluck(:document_type)).empty?
    end

    def docoments_not_self_employed_completed?
      required_documents = borrower.is_file_taxes_jointly ? DOCUMENTS_BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY : DOCUMENTS_BORROWER_NOT_SELF_EMPLOYED

      (required_documents - borrower.documents.pluck(:document_type)).empty?
    end
  end
end
