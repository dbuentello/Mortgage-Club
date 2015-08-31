include NumbersHelper

module Docusign
  module Templates
    class ServicingDisclosure
      attr_accessor :loan, :property, :borrower, :params

      def initialize(borrower, loan)
        @loan = loan
        @property = loan.property
        @borrower = borrower
        @params = {}

        build_header
        build_survey
      end

      private

      def build_header
        @params['lender_name'] = loan.lender_name
        @params['lender_address'] = loan.lender_address
        @params['date'] = Time.now.strftime("%m/%d/%Y")
      end

      def build_survey
        @params['assign_servicing_loan_outstanding'] = 'X'
        @params['assign_servicing_loan_before_first_payment'] = 'X'
        @params['loan_will_be_serviced'] = 'X'
      end

    end
  end
end