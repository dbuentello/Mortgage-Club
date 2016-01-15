# rubocop:disable ClassLength
module Docusign
  module Templates
    class UniformResidentialLoanApplication
      include ActionView::Helpers::NumberHelper
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
        @params["loan_amount"] = number_with_delimiter(loan.amount)
        @params["interest_rate"] = "#{(rand(0.1) * 100).round(3)}"
        @params["no_of_month"] = 124
        @params["amortization_fixed_rate"] = "x"
        @params["amortization_arm"] = "x"
      end

      def build_section_2
        @params["property_address"] = subject_property.address.try(:address)
        @params["no_of_units"] = rand(10)
        @params["legal_description"] = "See preliminary title"
        @params["loan_purpose_purchase"] = "x"
        @params["primary_property"] = "x"
        @params["secondary_property"] = "x"
        @params["investment_property"] = "x"
        @params["property_title"] = "To Be Determined"
        @params["property_manner"] = "To Be Determined in escrow"
        @params["property_fee_simple"] = "x"
        build_refinance_loan
      end

      def build_section_3
        build_borrower_info("borrower", borrower)
        build_borrower_info("co_borrower", loan.secondary_borrower)
      end

      def build_section_4
        build_employment_info("borrower", borrower)
        build_employment_info("co_borrower", loan.secondary_borrower)
        # TODO: add previous employment when duration < 2
      end

      def build_section_5
        build_gross_monthly_income("borrower", borrower)
        build_gross_monthly_income("co_borrower", loan.secondary_borrower)
        build_housing_expense("proposed", subject_property)
        build_housing_expense("present", primary_property)

        @params["final_total"] = number_with_delimiter(rand(100000))
        @params["total_net"] = align(number_with_delimiter(get_net_value), @params["final_total"].length)
        @params["total_base_income"] = align(number_with_delimiter(@params["total_base_income"].to_f + rand(1000)), @params["final_total"].length)
        @params["total_overtime"] = align(number_with_delimiter(@params["total_overtime"].to_f + rand(1000)), @params["final_total"].length)
        @params["total_bonuses"] = align(number_with_delimiter(@params["total_bonuses"].to_f + rand(1000)), @params["final_total"].length)
        @params["total_commissions"] = align(number_with_delimiter(@params["total_commissions"].to_f + rand(1000)), @params["final_total"].length)
        @params["total_dividends"] = align(number_with_delimiter(@params["total_dividends"].to_f + rand(1000)), @params["final_total"].length)
      end

      def build_section_6
        return unless credit_report

        [1, 2, 3].each do |index|
          nth = index.to_s
          @params["liabilities_name_" + nth] = "Lorem Ipsum"
          @params["liabilities_address_" + nth] = "Lorem Ipsum"
          @params["payment_months_" + nth] = rand(10090) / 10
          @params["unpaid_balance_" + nth] = rand(1000)
          @params["liabilities_acct_no_" + nth] = "Lorem Ipsum"
        end
      end

      def build_section_7
        # leave blank now
        # subordinate_financing
        @params["subordinate_financing"] = align(number_with_delimiter(rand(5000)), 9)
        @params["closing_costs_paid_by_seller"] = align(number_with_delimiter(rand(5000)), 9)
        @params["purchase_price"] = align(number_with_delimiter(rand(5000)), 9)
        @params["refinance"] = align(number_with_delimiter(loan.amount), 9)
        @params["estimated_prepaid_items"] = align(number_with_delimiter(rand(5000)), 9)
        @params["estimated_closing_costs"] = align(number_with_delimiter(rand(5000)), 9)
        @params["pmi_funding_fee"] = align(number_with_delimiter(rand(5000)), 9)
        @params["other_credit"] = align(number_with_delimiter(rand(5000)), 9)
        @params["loan_amount_exclude_pmi_mip"] = align(number_with_delimiter(rand(5000) - rand(5000)), 9)
        @params["pmi_mip_funding_fee_financed"] = align(number_with_delimiter(rand(5000)), 9)
        @params["total_loan_amount"] = align(number_with_delimiter(loan.amount.to_f), 9)
        @params["borrower_cash"] = align(number_with_delimiter(borrower_cash), 9)
        @params["total_cost_transactions"] = align(number_with_delimiter(total_cost_transactions), 9)
      end

      def build_section_8
        build_declaration("borrower", borrower)
        build_declaration("co_borrower", borrower)
      end

      def build_housing_expense(type, property)
        @params[type + "_total_expense"] = number_with_delimiter(rand(10000))
        @params[type + "_rent"] = align(number_with_delimiter(rand(1000)), @params[type + "_total_expense"].length)
        @params[type + "_first_mortgage"] = align(number_with_delimiter(rand(1000)), @params[type + "_total_expense"].length)
        @params[type + "_other_financing"] = align(number_with_delimiter(rand(1000)), @params[type + "_total_expense"].length)
        @params[type + "_hazard_insurance"] = align(number_with_delimiter(rand(1000)), @params[type + "_total_expense"].length)
        @params[type + "_estate_taxes"] = align(number_with_delimiter(rand(1000)), @params[type + "_total_expense"].length)
        @params[type + "_mortgage_insurance"] = align(number_with_delimiter(rand(1000)), @params[type + "_total_expense"].length)
        @params[type + "_homeowner"] = align(number_with_delimiter(rand(1000)), @params[type + "_total_expense"].length)
      end

      def total_cost_transactions
        @total_cost_transactions ||= rand(10000)
      end

      def borrower_cash
        subordinate_financing = 0
        closing_costs_paid_by_seller = 0
        total_cost_transactions - subordinate_financing - closing_costs_paid_by_seller -
          loan.other_credits.to_f - loan.amount.to_f
      end

      def build_declaration(role, borrower)
        #declarations_borrower_l_yes
        return unless declaration = borrower.declaration
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
          # if declaration.send(field)
            @params[prefix + midfix + key + yes_answer] = "x".freeze
          # else
            @params[prefix + midfix + key + no_answer] = "x".freeze
          # end
        end
        @params[prefix + midfix + "m_1"] = declaration.type_of_property
        @params[prefix + midfix + "m_2"] = declaration.title_of_property
      end

      def build_gross_monthly_income(role, borrower)
        @params[role + "_total_income"] = number_with_delimiter(rand(10000))
        @params[role + "_base_income"] = align(number_with_delimiter(rand(1000)), @params[role + "_total_income"].length)
        @params[role + "_overtime"] = align(number_with_delimiter(rand(1000)), @params[role + "_total_income"].length)
        @params[role + "_bonuses"] = align(number_with_delimiter(rand(10000)), @params[role + "_total_income"].length)
        @params[role + "_commissions"] = align(number_with_delimiter(rand(1000)), @params[role + "_total_income"].length)
        @params[role + "_dividends"] = align(number_with_delimiter(rand(1000)), @params[role + "_total_income"].length)
        @params["borrower_net"] = align(number_with_delimiter(get_net_value), @params["borrower_total_income"].length)
      end

      def build_employment_info(role, borrower)
        return unless current_employment = borrower.current_employment

        @params[role + "_self_employed_1"] = "x"
        @params[role + "_yrs_job"] = rand(10)
        @params[role + "_yrs_employed"] = rand(10)
        @params[role + "_name_employer_1"] = "Lorem Ipsum 113"
        @params[role + "_address_employer_1"] = "Lorem Ipsum 113"
        @params[role + "_position_1"] = "Lorem Ipsum 113"
        @params[role + "_business_phone_1"] = "Lorem Ipsum 113"
      end

      def build_borrower_info(role, borrower)
        @params[role + "_name"] = "Lorem Ipsum 113"
        @params[role + "_social_security_number"] = "343-4343-433"
        @params[role + "_home_phone"] = "032492343332"
        @params[role + "_dob"] = "3/1/1991"
        @params[role + "_yrs_school"] = "12"
        @params[role + "_married"] = "x"
        @params[role + "_unmarried"] = "x"
        @params[role + "_separated"] = "x"
        @params[role + "_dependents_no"] = "1"
        @params[role + "_dependents_ages"] = "2"
        @params[role + "_present_address"] = "Lorem Ipsum 113"
        @params[role + "_present_address_own"] = "x"
        @params[role + "_present_address_rent"] = "x"
        @params[role + "_present_address_no_yrs"] = "25"
        @params[role + "_former_address"] = "Lorem Ipsum 113"
        @params[role + "_former_address_own"] = "x"
        @params[role + "_former_address_rent"] = "x"
        @params[role + "_former_address_no_yrs"] = "33"
      end

      def build_refinance_loan
        @params["loan_purpose_refinance"] = "x"
        @params["refinance_year_acquired"] = rand(10)
        @params["refinance_original_cost"] = number_with_delimiter(rand(10000))
        @params["refinance_amount_existing_liens"] = number_with_delimiter(rand(10000))

        if loan.amount > subject_property.total_liability_balance
          @params["purpose_of_refinance"] = "Cash out"
        else
          @params["purpose_of_refinance"] = "Rate and term"
        end
        @params["year_built"] = rand(10)
        #If exists Asset.Bank account then source_down_payment = "Checking account"
        @params["source_down_payment"] = "Checking account"
      end

      def build_loan_type
          @params['mortgage_applied_conventional'] = 'x'
          @params['mortgage_applied_fha'] = 'x'
          @params['mortgage_applied_usda'] = 'x'
          @params['mortgage_applied_va'] = 'x'
          @params['mortgage_applied_other'] = 'x'
          @params['mortgage_applied_other_text'] = "Purchase"
      end

      def align(value, max_length)
        return unless value

        (value.length < max_length) ? value.rjust(max_length + 1) : value
      end

      def get_net_value
        @net_value ||= rand(1000)
      end
    end
  end
end