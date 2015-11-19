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