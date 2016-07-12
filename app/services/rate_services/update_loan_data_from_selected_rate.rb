# after use select a rate, we update rate's info to loan.
module RateServices
  class UpdateLoanDataFromSelectedRate
    ORIGINATION_TYPES = ["Loan discount fee", "Loan origination fee", "Processing fee", "Underwriting fee"]
    SERVICES_CAN_SHOP_TYPES = ["Wire transfer fee"]
    SERVICES_CANNOT_SHOP_TYPES = ["Appraisal fee", "Credit report fee"]

    def self.call(loan_id, fees, quote)
      loan = Loan.find(loan_id)
      lender = get_lender(quote[:lender_name])

      loan.tap do |l|
        l.lender = lender
        l.service_cannot_shop_fees = get_fees(fees, SERVICES_CANNOT_SHOP_TYPES)
        l.origination_charges_fees = get_fees(fees, ORIGINATION_TYPES)
        l.service_can_shop_fees = get_fees(fees, SERVICES_CAN_SHOP_TYPES)
        l.interest_rate = quote[:interest_rate].to_f
        l.lender_nmls_id = quote[:lender_nmls_id]
        l.num_of_months = quote[:period].to_i
        l.amortization_type = quote[:amortization_type]
        l.monthly_payment = quote[:monthly_payment].to_f
        l.apr = quote[:apr].to_f
        l.lender_credits = quote[:lender_credits].to_f
        l.loan_type = quote[:loan_type] ? quote[:loan_type].capitalize : nil
        l.estimated_closing_costs = quote[:total_closing_cost].to_f
        l.pmi_monthly_premium_amount = quote[:pmi_monthly_premium_amount].to_f
        l.amount = quote[:amount].to_f
        l.save
      end
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error("#LoanNotFound: cannot update loan's data from selected rate. Loan id: #{loan_id}")
    end

    def self.get_lender(lender_name)
      return Lender.dummy_lender unless lender = Lender.where(name: lender_name).last
      lender
    end

    def self.get_fees(fees, types)
      selected_fees = {}
      sum = 0

      selected_fees[:fees] = fees.to_a.map do |fee|
        next unless types.include? fee.last["Description"]

        amount = fee.last["FeeAmount"].to_f
        sum += amount
        {name: fee.last["Description"], amount: amount}
      end

      selected_fees[:fees].compact!
      selected_fees[:total] = sum
      selected_fees
    end
  end
end
