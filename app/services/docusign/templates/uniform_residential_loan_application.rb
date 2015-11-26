# rubocop:disable ClassLength
module Docusign
  module Templates
    class UniformResidentialLoanApplication
      attr_accessor :loan, :borrower, :subject_property, :primary_property, :credit_report, :params

      def initialize(loan)
        @loan = loan
        @subject_property = loan.subject_property
        @primary_property = loan.primary_property
        @borrower = loan.borrower
        @credit_report = borrower.credit_report
        @params = {}
      end

      def build
        build_section_1
        build_section_2
        build_section_3
        build_section_4
        build_section_5
        build_section_6
        build_section_7
        build_section_8
        params
      end

      def build_section_1
        # agency_case_number
        # lender_case_number
        build_loan_type
        @params["loan_amount"] = Money.new(loan.amount.to_f * 100).format
        @params["interest_rate"] = "#{(loan.interest_rate.to_f * 100).round(3)}%"
        @params["no_of_month"] = loan.num_of_months
        @params["amortization_fixed_rate"] = "x" if loan.fixed_rate_amortization?
        @params["amortization_arm"] = "x" if loan.arm_amortization?
      end

      def build_section_2
        @params["property_address"] = subject_property.address.try(:address)
        @params["no_of_units"] = subject_property.no_of_unit
        @params["legal_description"] = "See preliminary title"
        @params["loan_purpose_purchase"] = "x" if loan.purchase?
        @params["primary_property"] = "x" if subject_property.primary_residence?
        @params["secondary_property"] = "x" if subject_property.vacation_home?
        @params["investment_property"] = "x" if subject_property.rental_property?
        @params["property_title"] = "To Be Determined"
        @params["property_manner"] = "To Be Determined in escrow"
        @params["property_fee_simple"] = "x"
        build_refinance_loan if loan.refinance?
      end

      def build_section_3
        build_borrower_info("borrower", borrower)
        build_borrower_info("co_borrower", loan.secondary_borrower) if loan.secondary_borrower.present?
      end

      def build_section_4
        build_employment_info("borrower", borrower)
        build_employment_info("co_borrower", loan.secondary_borrower) if loan.secondary_borrower.present?
        # TODO: add previous employment when duration < 2
      end

      def build_section_5
        @params["borrower_net"] = UnderwritingLoanServices::CalculateRentalIncome.call(loan)
        build_gross_monthly_income("borrower", borrower)
        build_gross_monthly_income("co_borrower", loan.secondary_borrower) if loan.secondary_borrower.present?
        build_housing_expense("proposed", subject_property)
        build_housing_expense("present", primary_property) if primary_property
      end

      def build_section_6
        return unless credit_report

        credit_report.liabilities.includes(:address).each_with_index do |liability, index|
          nth = index.to_s
          @params["liabilities_name_" + nth] = liability.name
          @params["liabilities_address_" + nth] = liability.address.address
          @params["payment_months_" + nth] = liability.payment.to_f / liability.months.to_f
          @params["unpaid_balance_" + nth] = liability.balance
          @params["liabilities_acct_no_" + nth] = liability.account_number
        end
      end

      def build_section_7
        # leave blank now
        # subordinate_financing
        # closing_costs_paid_by_seller
        @params["refinance"] = Money.new(loan.amount * 100).format if loan.refinance?
        @params["estimated_prepaid_items"] = Money.new(loan.estimated_prepaid_items.to_f * 100).format
        @params["estimated_closing_costs"] = Money.new(loan.estimated_closing_costs.to_f * 100).format
        @params["pmi_funding_fee"] = Money.new(loan.pmi_mip_funding_fee.to_f * 100).format
        @params["other_credit"] = Money.new(loan.other_credits.to_f * 100).format
        @params["loan_amount_exclude_pmi_mip"] = Money.new((loan.amount.to_f - loan.pmi_mip_funding_fee.to_f) * 100).format
        @params["pmi_mip_funding_fee_financed"] = Money.new(loan.pmi_mip_funding_fee_financed.to_f * 100).format
        @params["total_loan_amount"] = Money.new(loan.amount.to_f * 100).format
        @params["borrower_cash"] = Money.new(borrower_cash * 100).format
        @params["total_cost_transactions"] = Money.new(total_cost_transactions * 100).format
      end

      def build_section_8
        build_declaration("borrower", borrower)
        build_declaration("co_borrower", loan.secondary_borrower) if loan.secondary_borrower.present?
      end

      def build_housing_expense(type, property)
        @params[type + "_rent"] = Money.new(borrower.current_address.monthly_rent * 100).format if primary_property && borrower.current_address.is_rental
        @params[type + "_first_mortgage"] = Money.new(property.mortgage_payment * 100).format
        @params[type + "_other_financing"] = Money.new(property.other_financing * 100).format
        @params[type + "_hazard_insurance"] = Money.new(property.estimated_hazard_insurance * 100).format
        @params[type + "_estate_taxes"] = Money.new(property.estimated_property_tax * 100).format
        @params[type + "_mortgage_insurance"] = Money.new(property.estimated_mortgage_insurance * 100).format
        @params[type + "_homeowner"] = Money.new(property.hoa_due * 100).format
        @params[type + "_total_expense"] = Money.new((property.mortgage_payment + property.other_financing +
                                            property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f +
                                            property.estimated_mortgage_insurance.to_f + property.hoa_due.to_f) * 100).format
      end

      def total_cost_transactions
        @total_cost_transactions ||=  subject_property.purchase_price.to_f + loan.estimated_prepaid_items.to_f +
                                      loan.estimated_closing_costs.to_f + loan.pmi_mip_funding_fee.to_f
      end

      def borrower_cash
        subordinate_financing = 0
        closing_costs_paid_by_seller = 0
        total_cost_transactions - subordinate_financing - closing_costs_paid_by_seller -
          loan.other_credits.to_f - loan.amount.to_f
      end

      def build_declaration(role, borrower)
        #declarations_borrower_l_yes
        declaration = borrower.declaration
        prefix = "declarations_".freeze
        midfix = (role + "_").freeze
        yes_answer = "_yes".freeze
        no_answer = "_no".freeze
        boolean_mapping = {
          "a" => "outstanding_judgment",
          "b" => "bankrupt",
          "c" => "property_foreclosed",
          "d" => "party_to_lawsuit",
          "e" => "loan_foreclosure",
          "f" => "present_delinquent_loan",
          "g" => "child_support",
          "h" => "down_payment_borrowed",
          "i" => "co_maker_or_endorser",
          "j" => "us_citizen",
          "k" => "permanent_resident_alien",
          "m" => "ownership_interest"
        }
        # Ex: @params["declarations_" + role + "_b_yes"] = "x" if declaration.bankrupt
        boolean_mapping.each do |key, field|
          @params[prefix + midfix + key + yes_answer] = @params[prefix + midfix + key + no_answer] = nil
          if declaration.send(field)
            @params[prefix + midfix + key + yes_answer] = "x".freeze
          else
            @params[prefix + midfix + key + no_answer] = "x".freeze
          end
        end
        @params[prefix + midfix + "m_1"] = declaration.type_of_property
        @params[prefix + midfix + "m_2"] = declaration.title_of_property
      end

      def build_gross_monthly_income(role, borrower)
        [
          "total_base_income", "total_overtime", "total_bonuses", "total_commissions",
          "total_dividends", "total_net", "total_other", "final_total"
        ].each { |field| @params[field] ||= 0 }

        @params[role + "_base_income"] = Money.new(borrower.current_salary * 100).format
        @params[role + "_overtime"] = Money.new(borrower.gross_overtime.to_f * 100).format
        @params[role + "_bonuses"] = Money.new(borrower.gross_bonus.to_f * 100).format
        @params[role + "_commissions"] = Money.new(borrower.gross_commission.to_f * 100).format
        @params[role + "_dividends"] = Money.new(borrower.gross_interest.to_f * 100).format
        @params[role + "_total_income"] = Money.new(borrower.total_income.to_f * 100).format
        @params["total_base_income"] += borrower.current_salary
        @params["total_overtime"] += borrower.gross_overtime.to_f
        @params["total_bonuses"] += borrower.gross_bonus.to_f
        @params["total_commissions"] += borrower.gross_commission.to_f
      end

      def build_employment_info(role, borrower)
        return unless current_employment = borrower.current_employment

        #borrower_self_employed_1
        @params[role + "_yrs_job"] = current_employment.duration
        @params[role + "_yrs_employed"] = current_employment.duration
        @params[role + "_name_employer_1"] = current_employment.employer_contact_name
        @params[role + "_address_employer_1"] = current_employment.full_address
        @params[role + "_position_1"] = current_employment.job_title
        @params[role + "_business_phone_1"] = current_employment.employer_contact_number
      end

      def build_borrower_info(role, borrower)
        @params[role + "_name"] = borrower.full_name
        @params[role + "_social_security_number"] = borrower.ssn
        @params[role + "_home_phone"] = borrower.phone
        @params[role + "_dob"] = borrower.dob
        @params[role + "_yrs_school"] = borrower.years_in_school
        @params[role + "_married"] = "x" if borrower.married?
        @params[role + "_unmarried"] = "x" if borrower.unmarried?
        @params[role + "_separated"] = "x" if borrower.separated?
        @params[role + "_dependents_no"] = borrower.dependent_count
        @params[role + "_dependents_ages"] = borrower.dependent_ages.join(", ")
        @params[role + "_present_address"] = borrower.display_current_address
        @params[role + "_present_address_own"] = "x" unless borrower.current_address.try(:is_rental)
        @params[role + "_present_address_rent"] = "x" if borrower.current_address.try(:is_rental)
        @params[role + "_present_address_no_yrs"] = borrower.current_address.try(:years_at_address)
        @params[role + "_former_address"] = borrower.display_previous_address
        @params[role + "_former_address_own"] = "x" unless borrower.previous_address.try(:is_rental)
        @params[role + "_former_address_rent"] = "x" if borrower.previous_address.try(:is_rental)
        @params[role + "_former_address_no_yrs"] = borrower.previous_address.try(:years_at_address)
      end

      def build_refinance_loan
        @params["loan_purpose_refinance"] = "x"
        @params["refinance_year_acquired"] = subject_property.original_purchase_year
        @params["refinance_original_cost"] = Money.new(subject_property.original_purchase_price.to_f * 100).format
        @params["refinance_amount_existing_liens"] = Money.new(subject_property.refinance_amount * 100).format

        if loan.amount > subject_property.total_liability_balance
          @params["purpose_of_refinance"] = "Cash out"
        else
          @params["purpose_of_refinance"] = "Rate and term"
        end
        @params["year_built"] = subject_property.year_built
        #If exists Asset.Bank account then source_down_payment = "Checking account"
        # source_down_payment
      end

      def build_loan_type
        case loan.loan_type
        when "Conventional"
          @params['mortgage_applied_conventional'] = 'x'
        when "FHA"
          @params['mortgage_applied_fha'] = 'x'
        when "USDA"
          @params['mortgage_applied_usda'] = 'x'
        when "VA"
          @params['mortgage_applied_va'] = 'x'
        else
          @params['mortgage_applied_other'] = 'x'
          @params['mortgage_applied_other_text'] = loan.loan_type
        end
      end
    end
  end
end