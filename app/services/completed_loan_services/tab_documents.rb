module CompletedLoanServices
  class TabDocuments
    attr_accessor :borrower, :secondary_borrower

    def initialize(args)
      @borrower = args[:borrower]
      @secondary_borrower = args[:secondary_borrower]
    end

    def call
      return borrower_documents_completed?(borrower) unless secondary_borrower.present?
      borrower_documents_completed?(borrower) && co_borrower_documents_completed?(secondary_borrower)
    end

    def borrower_documents_completed?(borrower)
      if borrower.self_employed
        required_documents = %w(first_personal_tax_return second_personal_tax_return
                                first_business_tax_return second_business_tax_return
                                first_bank_statement second_bank_statement)
      else
        required_documents = %w(first_w2 second_w2 first_paystub second_paystub
                                first_federal_tax_return second_federal_tax_return
                                first_bank_statement second_bank_statement)
      end

      (required_documents - borrower.documents.pluck(:document_type)).empty?
    end

    def co_borrower_documents_completed?(borrower)
      if borrower.self_employed
        if borrower.is_file_taxes_jointly
          required_documents = %w(first_business_tax_return second_business_tax_return first_bank_statement second_bank_statement)
        else
          required_documents = %w(first_personal_tax_return second_personal_tax_return first_business_tax_return second_business_tax_return first_bank_statement second_bank_statement)
        end
        return (required_documents - borrower.documents.pluck(:document_type)).empty?
      else
        if borrower.is_file_taxes_jointly
          required_documents = %w(first_w2 second_w2 first_paystub second_paystub  first_bank_statement second_bank_statement)
        else
          required_documents = %w(first_w2 second_w2 first_paystub second_paystub first_federal_tax_return second_federal_tax_return  first_bank_statement second_bank_statement)
        end
        return (required_documents - borrower.documents.pluck(:document_type)).empty?
      end
    end
  end
end
