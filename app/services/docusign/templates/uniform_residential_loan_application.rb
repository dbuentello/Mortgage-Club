module Docusign
  module Templates
    class UniformResidentialLoanApplication
      attr_accessor :loan, :property, :borrower, :params

      def initialize(loan)
        @loan = loan
        @property = loan.primary_property
        @borrower = loan.borrower
        @params = {}
      end

      def build_section_1
        # agency_case_number. These fields will be mapped after we have loan shifter.
        # lender_case_number
        build_loan_type
        @params["loan_amount"] = Money.new(loan.amount.to_f * 100).format
        @params["interest_rate"] = "#{(loan.interest_rate.to_f * 100).round(3)}%"
        @params["no_of_month"] = loan.num_of_months
        @params["amortization_fixed_rate"] = "x" if loan.fixed_rate_amortization?
        @params["amortization_arm"] = "x" if loan.arm_amortization?
      end

      def build_section_2
        @params["property_address"] = property.address.try(:address)
        @params["no_of_units"] = property.no_of_unit
        @params["legal_description"] = "See preliminary title"
        @params["loan_purpose_purchase"] = "x" if loan.purchase?
        build_refinance_loan if loan.refinance?
        @params["primary_property"] = "x" if property.primary_residence?
        @params["secondary_property"] = "x" if property.vacation_home?
        @params["investment_property"] = "x" if property.rental_property?
        @params["property_title"] = "To Be Determined"
        @params["property_manner"] = "To Be Determined in escrow"
        @params["property_fee_simple"] = "x"
        # purpose_of_refinance
        # source_down_payment
        # year_built
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

        # TODO: these below fields will be mapped after we complete UI for subject property
        # present_rent, present_first_mortgage, present_other_financing
        # present_hazard_insurance, present_estate_taxes, present_mortgage_insurance
        # present_homeowner, present_total_expense, proposed_first_mortgage
        # proposed_other_financing, proposed_hazard_insurance, proposed_estate_taxes
        # proposed_mortgage_insurance, proposed_homeowner, proposed_total_expense
      end

      def build_gross_monthly_income(role, borrower)
        # borrower_dividends, borrower_net, borrower_other
        [
          "total_base_income", "total_overtime", "total_bonuses", "total_commissions",
          "total_dividends", "total_net", "total_other", "final_total"
        ].each { |field| @params[field] ||= 0 }

        @params[role + "_base_income"] = Money.new(borrower.current_salary * 100).format
        @params[role + "_overtime"] = Money.new(borrower.gross_overtime.to_f * 100).format
        @params[role + "_bonuses"] = Money.new(borrower.gross_bonus.to_f * 100).format
        @params[role + "_commissions"] = Money.new(borrower.gross_commission.to_f * 100).format
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
        @params[role + "_dependents_ages"] = borrower.dependent_ages
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
        @params["refinance_year_acquired"] = property.original_purchase_year
        @params["refinance_original_cost"] = property.original_purchase_price
        @params["refinance_amount_existing_liens"] = property.refinance_amount
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