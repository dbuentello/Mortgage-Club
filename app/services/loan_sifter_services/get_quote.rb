module LoanSifterServices
  class GetQuote
    attr_accessor :loan, :borrower

    def initialize(loan)
      @loan = loan
      @borrower = loan.borrower
      @property = loan.subject_property
      @declaration = borrower.declaration
    end

    def call
    end

    private

    def asset_documentation
      "Verified"
    end

    def underwriting_system_name
      "DU"
    end

    def bankruptcy
      declaration.bankrupt ? "Yes" : "Never"
    end

    def application_date
      loan.created_at.strftime('%D')
    end

    def borrower_monthly_income
      borrower.gross_income
    end

    def citizenship
      declaration.us_citizen ? "U.S. Citizen" : nil
    end

    def employment_documentation
    end

    def foreclosure
      declaration.loan_foreclosure ? "Yes" : "Never"
    end

    def income_documentation
    end

    def loan_amount
      loan.amount
    end

    def loan_purpose
      loan.purpose_titleize
    end

    def street_address
      property.address.street_address
    end

    def city
      property.address.city
    end

    def postal_code
      property.address.zip
    end

    def state_name
      property.address.state
    end

    def property_type
      type = ""
      case property.property_type
      when "sfh"
        type = "Single Family"
      when "duplex"
        type = "Duplex"
      when "triplex"
        type = "Triplex"
      when "fourplex"
        type = "Fourplex"
      when "condo"
        type = "Condominium"
      end
      type
    end

    def property_usage
      usage = ""
      case property.usage
      when "primary_residence"
        usage = "Primary Residence"
      when "vacation_home"
        usage = "Vacation Home"
      when "rental_property"
        usage = "Rental Property"
      end
      usage
    end

    def purchase_price_amount
      property.purchase? ? property.purchase_price : 0
    end

    def refinance_cash_out_amount
      property.refinance? property.original_purchase_price : 0
    end

    def self_employed_indicator
      borrower.self_employed ? "Yes" : "No"
    end
  end
end
