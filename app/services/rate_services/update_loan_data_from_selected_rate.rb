# after use select a rate, we update rate's info to loan.
module RateServices
  class UpdateLoanDataFromSelectedRate
    def self.call(loan_id, fees, quote, thirty_fees)
      loan = Loan.find(loan_id)
      lender = get_lender(quote[:lender_name])
      fees = JSON.load fees
      thirty_fees = JSON.load thirty_fees

      loan.tap do |l|
        l.lender = lender
        l.lender_underwriting_fee = fees.first ? fees.first["FeeAmount"] : 0.0

        l.appraisal_fee = get_fee(thirty_fees, "Services you cannot shop for", "Appraisal Fee")
        l.tax_certification_fee = get_fee(thirty_fees, "Services you cannot shop for", "Tax Certification Fee")
        l.flood_certification_fee = get_fee(thirty_fees, "Services you cannot shop for", "Flood Certification Fee")
        l.outside_signing_service_fee = get_fee(thirty_fees, "Services you can shop for", "Outside Signing Service")
        l.concurrent_loan_charge_fee = get_fee(thirty_fees, "Services you can shop for", "Title - Concurrent Loan Charge")
        l.endorsement_charge_fee = get_fee(thirty_fees, "Services you can shop for", "Endorsement Charge")
        l.lender_title_policy_fee = get_fee(thirty_fees, "Services you can shop for", "Title - Lender's Title Policy")
        l.recording_service_fee = get_fee(thirty_fees, "Services you can shop for", "Title - Recording Service Fee")
        l.settlement_agent_fee = get_fee(thirty_fees, "Services you can shop for", "Title - Settlement Agent Fee")
        l.recording_fees = get_fee(thirty_fees, "Taxes and other government fees", "Recording Fees")
        l.owner_title_policy_fee = get_fee(thirty_fees, "Other", "Title - Owner's Title Policy")
        l.prepaid_item_fee = get_fee(thirty_fees, "Prepaid items", "Prepaid interest")
        l.prepaid_homeowners_insurance = loan.subject_property.estimated_hazard_insurance.to_f

        l.cash_out = quote[:cash_out].to_f
        l.interest_rate = quote[:interest_rate].to_f
        l.lender_nmls_id = quote[:lender_nmls_id]
        l.num_of_months = quote[:period].to_i
        l.amortization_type = quote[:amortization_type]
        l.monthly_payment = quote[:monthly_payment].to_f
        l.apr = quote[:apr].to_f
        l.lender_credits = quote[:lender_credits].to_f
        loan_type = quote[:loan_type] ? quote[:loan_type].capitalize : nil
        if loan_type.downcase.include? "conventional"
          l.loan_type = "Conventional"
        else
          l.loan_type = loan_type.upcase
        end
        l.estimated_closing_costs = quote[:total_closing_cost].to_f + loan.subject_property.estimated_hazard_insurance.to_f
        l.pmi_monthly_premium_amount = quote[:pmi_monthly_premium_amount].to_f
        l.amount = quote[:amount].to_f
        l.discount_pts = quote[:discount_pts].to_f
        l.updated_rate_time = Time.zone.now
        l.save!
      end

    rescue ActiveRecord::RecordNotFound
      Rails.logger.error("#LoanNotFound: cannot update loan's data from selected rate. Loan id: #{loan_id}")
    end

    def self.get_lender(lender_name)
      return Lender.dummy_lender unless lender = Lender.where(name: lender_name).last
      lender
    end

    def self.get_fee(thirty_fees, group_name, field_name)
      group = thirty_fees.find { |fees| fees["Description"] == group_name }
      return 0.0 unless group

      field = group["Fees"].find { |fee| fee["Description"].index(field_name).present? }
      return 0.0 unless field

      field["FeeAmount"].to_f
    end

    def self.update_rate(loan, rate)
      fees = rate[:fees]
      thirty_fees = JSON.load(rate[:thirty_fees].to_json)
      lender = get_lender(rate[:lender_name])

      loan.tap do |l|
        l.lender_underwriting_fee = fees.first ? fees.first["FeeAmount"] : 0.0

        l.appraisal_fee = get_fee(thirty_fees, "Services you cannot shop for", "Appraisal Fee")
        l.tax_certification_fee = get_fee(thirty_fees, "Services you cannot shop for", "Tax Certification Fee")
        l.flood_certification_fee = get_fee(thirty_fees, "Services you cannot shop for", "Flood Certification Fee")
        l.outside_signing_service_fee = get_fee(thirty_fees, "Services you can shop for", "Outside Signing Service")
        l.concurrent_loan_charge_fee = get_fee(thirty_fees, "Services you can shop for", "Title - Concurrent Loan Charge")
        l.endorsement_charge_fee = get_fee(thirty_fees, "Services you can shop for", "Endorsement Charge")
        l.lender_title_policy_fee = get_fee(thirty_fees, "Services you can shop for", "Title - Lender's Title Policy")
        l.recording_service_fee = get_fee(thirty_fees, "Services you can shop for", "Title - Recording Service Fee")
        l.settlement_agent_fee = get_fee(thirty_fees, "Services you can shop for", "Title - Settlement Agent Fee")
        l.recording_fees = get_fee(thirty_fees, "Taxes and other government fees", "Recording Fees")
        l.owner_title_policy_fee = get_fee(thirty_fees, "Other", "Title - Owner's Title Policy")
        l.prepaid_item_fee = get_fee(thirty_fees, "Prepaid items", "Prepaid interest")
        l.prepaid_homeowners_insurance = loan.subject_property.estimated_hazard_insurance.to_f

        l.lender_nmls_id = rate[:lender_nmls_id]
        l.lender = lender

        l.num_of_months = rate[:period].to_i
        l.monthly_payment = rate[:monthly_payment].to_f
        l.apr = rate[:apr].to_f
        l.lender_credits = rate[:lender_credits].to_f
        l.estimated_closing_costs = rate[:total_closing_cost].to_f + loan.subject_property.estimated_hazard_insurance.to_f
        l.pmi_monthly_premium_amount = rate[:pmi_monthly_premium_amount].to_f
        l.amount = rate[:loan_amount].to_f
        l.discount_pts = rate[:discount_pts].to_f
        l.save!
      end
    end
  end
end
