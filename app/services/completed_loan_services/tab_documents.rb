module CompletedLoanServices
  class TabDocuments < Base
    def self.call(loan)
      @loan = loan

      return borrower_documents_completed?(@loan.borrower) unless @loan.secondary_borrower.present?
      borrower_documents_completed?(@loan.borrower) && co_borrower_documents_completed?(secondary_borrower)
    end

    def self.borrower_documents_completed?(borrower)
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

    def self.co_borrower_documents_completed?(borrower)
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
