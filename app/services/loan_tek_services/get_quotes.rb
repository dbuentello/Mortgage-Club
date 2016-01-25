module LoanTekServices
  class GetQuotes
    attr_reader :loan, :property, :borrower

    def initialize(loan)
      @loan = loan
      @property = loan.subject_property
      @borrower = loan.borrower
    end

    def call
    end

    private

    def execution_method
      # NotSpecified
      # 0
      # ByPointGroup
      # 1
      # ByRate
      # 2
      # JustRemoveStops
      # 3
      # ByLoanProduct
      # 4
      # ByPointGroupRateInsteadOfAPR
      # 5
    end

    def quoting_channel
      # NotSpecified
      # -1
      # NotChannelSpecific
      # 0
      # Zillow
      # 1
      # Bankrate
      # 2
      # LoanTek
      # 3
      # LendingTreeLoanExplorer
      # 4
      # LendingTreeLongForm
      # 8
      # QuinStreet
      # 9
      # Informa
      # 10
      # MyBankTracker
      # 11
      # CampaignRateTable
      # 12
      # WebQuote
      # 13
      # Zenlen
      # 14
      # MortgageProfessor
      # 15
    end

    def client_defined_identifier
      "MC2016!"
    end

    def zipcode
      property.address.zip
    end

    def credit_score
      borrower.credit_score.to_i
    end

    def loan_purpose
      if loan.purchase?
        purpose = 1
      elsif loan.refinance?
        purpose = 2
      else
        purpose = 0
      end

      purpose
    end

    def loan_amount
      loan.amount.to_i
    end

    def loan_to_value
      property_value = loan.purchase? ? property.purchase_price : property.original_purchase_price
      loan_amount * 100 / property_value
    end

    def property_usage
      if property.primary_residence?
        usage = 1
      elsif property.vacation_home?
        usage = 2
      else
        usage = 3
      end

      usage
    end

    def property_type
    end

    def loan_programs
    end
  end
end