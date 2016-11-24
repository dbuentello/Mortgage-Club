module LoanTekServices
  class GetQuotesForFacebookBot
    attr_reader :parameters, :quotes, :zip_code

    def initialize(params)
      @parameters = params
      @quotes = []
      @zip_code = ZipCode.find_by_zip(params[:zipcode])
    end

    def call
      return false unless parameters

      @quotes = LoanTekServices::SendRequestToLoanTek.call(
        zipcode: get_zipcode,
        credit_score: get_credit_score,
        loan_purpose: get_loan_purpose,
        loan_amount: get_loan_amount,
        loan_to_value: get_loan_to_value,
        property_usage: get_property_usage,
        property_type: get_property_type
      )

      if zip_code
        fees = CrawlFeesService.new(
          loan_purpose: get_loan_purpose,
          zip: zip_code.zip,
          city: zip_code.city,
          county: zip_code.county,
          loan_amount: get_loan_amount,
          sales_price: get_property_value
        ).call

        if get_property_usage == "PrimaryResidence"
          params = {
            loan_purpose: get_loan_purpose,
            loan_amount: format("%0.0f", get_loan_amount),
            property_value: format("%0.0f", get_property_value),
            county: zip_code.county,
            down_payment: purchase_loan? ? format("%0.0f", get_down_payment) : ""
          }

          rates = WellsfargoServices::GetRates.new(params).call
          quote_hash = quotes.find { |q| q["ProductFamily"] == "CONVENTIONAL" }

          if quote_hash
            rates.each do |rate|
              quote = Marshal.load(Marshal.dump(quote_hash))
              quote["DiscountPts"] = 0
              quote["APR"] = rate[:apr]
              quote["Rate"] = rate[:interest_rate]
              quote["LenderName"] = rate[:lender_name]
              quote["ProductName"] = rate[:product_name]
              quote["ProductType"] = rate[:product_type]
              quote["ProductTerm"] = rate[:product_term]
              quotes << quote
            end
          end
        end

        if quotes.nil?
          @quotes = []
        else
          @quotes = quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose, fees, get_property_value, false, false)
        end
      else
        if quotes.nil?
          @quotes = []
        else
          @quotes = quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose, [], get_property_value, false, false)
        end
      end

      quotes.present?
    end

    def query_content
      {
        zip_code: get_zipcode,
        credit_score: get_credit_score,
        mortgage_purpose: parameters[:purpose],
        property_value: get_property_value,
        property_usage: parameters[:usage],
        property_type: parameters[:property_type],
        down_payment: get_down_payment,
        mortgage_balance: get_mortgage_balance
      }.to_json
    end

    private

    def get_loan_to_value
      loan_amount = get_loan_amount
      property_value = get_property_value

      (loan_amount * 100 / property_value).round(3)
    end

    def get_zipcode
      parameters[:zipcode].to_i
    end

    def get_credit_score
      parameters[:credit_score].to_i
    end

    def get_loan_purpose
      if purchase_loan?
        purpose = "Purchase"
      elsif refinance_loan?
        purpose = "Refinance"
      end

      purpose
    end

    def get_loan_amount
      property_value = get_property_value
      down_payment = get_down_payment

      if purchase_loan?
        amount = property_value - down_payment
      elsif refinance_loan?
        amount = get_mortgage_balance
      end

      amount.to_i
    end

    def get_property_usage
      case parameters[:usage]
      when "primary_residence"
        usage = "PrimaryResidence"
      when "vacation_home"
        usage = "SecondaryOrVacation"
      when "rental_property"
        usage = "InvestmentOrRental"
      when "investment_property"
        usage = "InvestmentOrRental"
      else
        usage = "NotSpecified"
      end
      usage
    end

    def get_property_type
      case parameters[:property_type]
      when "sfh"
        property_type = "SingleFamily"
      when "multi_family"
        property_type = "MultiFamily2Units"
      when "condo"
        property_type = "Condo"
      else
        property_type = "NotSpecified"
      end
      property_type
    end

    def get_property_value
      parameters[:property_value].to_i
    end

    def get_mortgage_balance
      parameters[:mortgage_balance].to_i
    end

    def get_down_payment
      parameters[:down_payment].to_i
    end

    def purchase_loan?
      parameters[:purpose] == "purchase"
    end

    def refinance_loan?
      parameters[:purpose] == "refinance"
    end
  end
end
