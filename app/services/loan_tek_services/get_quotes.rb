module LoanTekServices
  class GetQuotes
    attr_reader :loan, :property, :borrower

    def initialize(loan)
      @loan = loan
      @property = loan.subject_property
      @borrower = loan.borrower
    end

    def call
      url ="https://api.loantek.com/Clients/WebServices/Client/#{client_id}/Pricing/V2/Quotes/LoanPricer/#{user_id}"
      connection = Faraday.new(url: url)
      response = connection.post do |conn|
        conn.params["BestExecutionMethodType"] = execution_method
        conn.params["QuotingChannel"] = quoting_channel
        conn.params["ClientDefinedIdentifier"] = client_defined_identifier
        conn.params["ZipCode"] = zipcode
        conn.params["CreditScore"] = credit_score
        conn.params["LoanPurpose"] = loan_purpose
        conn.params["LoanAmount"] = loan_amount
        conn.params["LoanToValue"] = loan_to_value
        conn.params["PropertyUsage"] = property_usage
        conn.params["PropertyType"] = property_type
      end

      result = JSON.parse(response.body)
      return result["Quotes"] if result["QuotesCount"] > 0
    end

    private

    def client_id
      "lorem"
    end

    def user_id
      "ipsum"
    end

    def execution_method
      0
    end

    def quoting_channel
      0
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
      purpose = 0
      if loan.purchase?
        purpose = 1
      elsif loan.refinance?
        purpose = 2
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
      case property_usage
      when "primary_residence"
        usage = 1
      when "vacation_home"
        usage = 2
      when "rental_property"
        usage = 3
      end

      usage
    end

    def property_type
      case property.property_type
      when "sfh"
        property_type = 1
      when "duplex"
        property_type = 11
      when "triplex"
        property_type = 12
      when "fourplex"
        property_type = 13
      when "condo"
        property_type = 3
      else
        property_type = 0
      end
      property_type
    end

    def loan_programs
      [0]
    end
  end
end