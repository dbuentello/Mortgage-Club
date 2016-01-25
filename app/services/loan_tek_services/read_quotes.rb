module LoanTekServices
  class ReadQuotes
    def self.call(quotes)
      quotes.map! do |quote|
        lender_name = quote["LenderName"]
        product = quote["ProductName"]
        nmls = "foo"
        apr = quote["APR"]
        monthly_payment = "foo"
        loan_amount = quote["LoanAmount"]
        interest_rate = quote["Rate"]
        total_fee = quote["Feeset"]["TotalFees"]
        fees = quote["FeeSet"]["Fees"] || []
      end
    end
  end
end
