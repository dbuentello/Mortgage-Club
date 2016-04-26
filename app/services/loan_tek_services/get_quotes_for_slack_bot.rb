module LoanTekServices
  class GetQuotesForSlackBot
    attr_reader :data, :context, :response, :result

    def initialize(params)
      @data = params["result"] if params["result"].present?
      @context = data["contexts"].last if @data
      @response = []
      @result = []
    end

    def call
      return false unless data && context

      quotes = LoanTekServices::SendRequestToLoanTek.call(
        zipcode: get_zipcode,
        credit_score: get_credit_score,
        loan_purpose: get_loan_purpose,
        loan_amount: get_loan_amount,
        loan_to_value: get_loan_to_value,
        property_usage: get_property_usage,
        property_type: get_property_type
      )

      quotes.present?
    end

    def query_content
      {
        zip_code: get_zipcode,
        credit_score: get_credit_score,
        mortgage_purpose: context["parameters"]["purpose"],
        property_value: property_value,
        property_usage: context["parameters"]["usage"],
        property_type: context["parameters"]["property_type"],
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
      context["parameters"]["zipcode"].to_i
    end

    def get_credit_score
      return unless data["parameters"]

      data["parameters"]["credit_score"].to_i
    end

    def get_loan_purpose
      if purchase_loan?
        purpose = 1
      elsif refinance_loan?
        purpose = 2
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
      case context["parameters"]["usage"]
      when "primary_residence"
        usage = 1
      when "vacation_home"
        usage = 2
      when "rental_property"
        usage = 3
      else
        usage = 0
      end
      usage
    end

    def get_property_type
      case context["parameters"]["property_type"]
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

    def get_property_value
      context["parameters"]["property_value"].to_i
    end

    def get_mortgage_balance
      context["parameters"]["mortgage_balance"].to_i
    end

    def get_down_payment
      context["parameters"]["down_payment"].to_i
    end

    def purchase_loan?
      context["parameters"]["purpose"] == "purchase"
    end

    def refinance_loan?
      context["parameters"]["purpose"] == "refinance"
    end
  end
end
