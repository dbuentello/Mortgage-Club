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
        build_section_10
        params
      end

      def build_section_1
        # agency_case_number
        # lender_case_number
        build_loan_type
        @params["loan_amount"] = number_with_delimiter(loan.amount.to_f)
        @params["interest_rate"] = "#{(loan.interest_rate.to_f * 100).round(3)}"
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
        build_gross_monthly_income("borrower", borrower)
        build_gross_monthly_income("co_borrower", loan.secondary_borrower) if loan.secondary_borrower.present?
        build_housing_expense("proposed", subject_property)
        build_housing_expense("present", primary_property) if primary_property

        @params["borrower_net"] = align(number_with_delimiter(get_net_value), @params["borrower_total_income"].length) if @params["borrower_total_income"]
        @params["final_total"] = number_with_delimiter(@params["total_base_income"].to_f + @params["total_overtime"].to_f +
                                                       @params["total_bonuses"].to_f + @params["total_commissions"].to_f +
                                                       @params["total_dividends"].to_f)
        if @params["final_total"]
          @params["total_base_income"] = align(number_with_delimiter(@params["total_base_income"].to_f), @params["final_total"].length)
          @params["total_overtime"] = align(number_with_delimiter(@params["total_overtime"].to_f), @params["final_total"].length)
          @params["total_bonuses"] = align(number_with_delimiter(@params["total_bonuses"].to_f), @params["final_total"].length)
          @params["total_commissions"] = align(number_with_delimiter(@params["total_commissions"].to_f), @params["final_total"].length)
          @params["total_dividends"] = align(number_with_delimiter(@params["total_dividends"].to_f), @params["final_total"].length)
          @params["total_net"] = align(number_with_delimiter(get_net_value), @params["final_total"].length)
        end
      end

      def build_section_6
        return unless credit_report

        credit_report.liabilities.includes(:address).each_with_index do |liability, index|
          nth = index.to_s
          @params["liabilities_name_" + nth] = liability.name
          if liability.address
            @params["liabilities_street_" + nth] = liability.address.street_address
            @params["liabilities_city_and_state_" + nth] = "#{liability.address.city}, #{liability.address.state} #{liability.address.zip}"
          end

          @params["payment_months_" + nth] = liability.payment.to_f / liability.months.to_f
          @params["unpaid_balance_" + nth] = liability.balance
          @params["liabilities_acct_no_" + nth] = liability.account_number
        end
      end

      def build_section_7
        # leave blank now
        # subordinate_financing
        # closing_costs_paid_by_seller
        @params["purchase_price"] = align(number_with_delimiter(subject_property.purchase_price), 9)
        @params["refinance"] = align(number_with_delimiter(loan.amount), 9) if loan.refinance?
        @params["estimated_prepaid_items"] = align(number_with_delimiter(loan.estimated_prepaid_items), 9)
        @params["estimated_closing_costs"] = align(number_with_delimiter(loan.estimated_closing_costs), 9)
        @params["pmi_funding_fee"] = align(number_with_delimiter(loan.pmi_mip_funding_fee), 9)
        @params["other_credit"] = align(number_with_delimiter(loan.other_credits), 9)
        @params["loan_amount_exclude_pmi_mip"] = align(number_with_delimiter(loan.amount - loan.pmi_mip_funding_fee.to_f), 9)
        @params["pmi_mip_funding_fee_financed"] = align(number_with_delimiter(loan.pmi_mip_funding_fee_financed.to_f), 9)
        @params["total_loan_amount"] = align(number_with_delimiter(loan.amount), 9)
        @params["borrower_cash"] = align(number_with_delimiter(borrower_cash), 9)
        @params["total_cost_transactions"] = align(number_with_delimiter(total_cost_transactions), 9)
      end

      def build_section_8
        build_declaration("borrower", borrower)
        build_declaration("co_borrower", loan.secondary_borrower) if loan.secondary_borrower.present?
      end

      def build_section_10
        @params["borrower_do_not_wish"] = "x"
        @params["co_borrower_do_not_wish"] = "x" if loan.secondary_borrower
        @params["applicant_submitted_internet"] = "x"
      end

      def build_housing_expense(type, property)
        @params[type + "_total_expense"] = number_with_delimiter((property.mortgage_payment + property.other_financing +
                                            property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f +
                                            property.estimated_mortgage_insurance.to_f + property.hoa_due.to_f))

        @params[type + "_rent"] = align(number_with_delimiter(borrower.current_address.monthly_rent), @params[type + "_total_expense"].length) if primary_property && borrower.current_address.is_rental
        @params[type + "_first_mortgage"] = align(number_with_delimiter(property.mortgage_payment), @params[type + "_total_expense"].length)
        @params[type + "_other_financing"] = align(number_with_delimiter(property.other_financing), @params[type + "_total_expense"].length)
        @params[type + "_hazard_insurance"] = align(number_with_delimiter(property.estimated_hazard_insurance), @params[type + "_total_expense"].length)
        @params[type + "_estate_taxes"] = align(number_with_delimiter(property.estimated_property_tax), @params[type + "_total_expense"].length)
        @params[type + "_mortgage_insurance"] = align(number_with_delimiter(property.estimated_mortgage_insurance), @params[type + "_total_expense"].length)
        @params[type + "_homeowner"] = align(number_with_delimiter(property.hoa_due), @params[type + "_total_expense"].length)
      end

      def total_cost_transactions
        @total_cost_transactions ||=  (subject_property.purchase_price.to_f + loan.estimated_prepaid_items.to_f +
                                      loan.estimated_closing_costs.to_f + loan.pmi_mip_funding_fee.to_f).round(2)
      end

      def borrower_cash
        subordinate_financing = 0
        closing_costs_paid_by_seller = 0
        (total_cost_transactions - subordinate_financing - closing_costs_paid_by_seller -
          loan.other_credits.to_f - loan.amount.to_f).round(2)
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
        @params[role + "_total_income"] = number_with_delimiter(borrower.total_income)
        @params[role + "_base_income"] = align(number_with_delimiter(borrower.current_salary), @params[role + "_total_income"].length)
        @params[role + "_overtime"] = align(number_with_delimiter(borrower.gross_overtime), @params[role + "_total_income"].length)
        @params[role + "_bonuses"] = align(number_with_delimiter(borrower.gross_bonus), @params[role + "_total_income"].length)
        @params[role + "_commissions"] = align(number_with_delimiter(borrower.gross_commission), @params[role + "_total_income"].length)
        @params[role + "_dividends"] = align(number_with_delimiter(borrower.gross_interest), @params[role + "_total_income"].length)

        @params["total_base_income"] = @params["total_base_income"].to_f + borrower.current_salary
        @params["total_overtime"] = @params["total_overtime"].to_f + borrower.gross_overtime.to_f
        @params["total_bonuses"] = @params["total_bonuses"].to_f + borrower.gross_bonus.to_f
        @params["total_commissions"] = @params["total_commissions"].to_f + borrower.gross_commission.to_f
        @params["total_dividends"] = @params["total_dividends"].to_f + borrower.gross_interest.to_f
      end

      def build_employment_info(role, borrower)
        @params[role + "_yrs_job"] = borrower.current_employment.duration
        @params[role + "_yrs_employed"] = borrower.current_employment.duration

        [borrower.current_employment, borrower.previous_employment].each_with_index do |employment, index|
          next if employment.nil?
          #borrower_self_employed_1
          @params[role + "_name_employer_#{index + 1}"] = employment.employer_name
          if employment.address
            @params[role + "_street_employer_#{index + 1}"] = employment.address.street_address
            @params[role + "_city_and_state_employer_#{index + 1}"] = "#{employment.address.city}, #{employment.address.state} #{employment.address.zip}"
          end
          @params[role + "_position_#{index + 1}"] = employment.job_title
          @params[role + "_business_phone_#{index + 1}"] = employment.employer_contact_number
        end
      end

      def build_borrower_info(role, borrower)
        @params[role + "_name"] = borrower.full_name
        @params[role + "_social_security_number"] = borrower.ssn
        @params[role + "_home_phone"] = borrower.phone
        @params[role + "_dob"] = borrower.dob.strftime('%D') if borrower.dob
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
        @params["refinance_original_cost"] = number_with_delimiter(subject_property.original_purchase_price)
        @params["refinance_amount_existing_liens"] = number_with_delimiter(subject_property.refinance_amount)

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

      def align(value, max_length)
        return unless value

        (value.length < max_length) ? value.rjust(max_length + 1) : value
      end

      def get_net_value
        @net_value ||= UnderwritingLoanServices::CalculateRentalIncome.call(loan)
      end
    end
  end
end