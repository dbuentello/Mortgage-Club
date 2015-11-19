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
        @params["loan_amount"] = Money.new(loan.amount * 100).format
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
        build_borrower_info("borrower")
        build_borrower_info("co_borrower") if loan.secondary_borrower.present?
      end

      def build_borrower_info(role)
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
        # @params[role + "_present_address_own"] =
        # @params[role + "_present_address_rent"] =
        # @params[role + "_present_address_no_yrs"] =
        @params[role + "_former_address"] = borrower.display_previous_address
        # @params[role + "_former_address_own"] =
        # @params[role + "_former_address_rent"] =
        # @params[role + "_former_address_no_yrs"] =
        # create_table "borrower_addresses", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
        #   t.uuid     "borrower_id"
        #   t.integer  "years_at_address"
        #   t.boolean  "is_rental"
        #   t.boolean  "is_current",       default: false, null: false
        #   t.datetime "created_at"
        #   t.datetime "updated_at"
        # end
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