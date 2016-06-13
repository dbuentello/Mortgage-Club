module Docusign
  module Templates
    #
    # Class ServicingDisclosure provides mapping values to Servicing Disclosure form.
    #
    #
    #
    class ServicingDisclosure
      attr_accessor :loan, :params

      def initialize(loan)
        @loan = loan
        @params = {}
      end

      def build
        build_header
        build_survey
        params
      end

      private

      def build_header
        @params['lender_name'] = loan.lender.name
        @params['lender_address'] = loan.lender_address
        @params['date'] = Time.zone.now.strftime("%m/%d/%Y")
      end

      def build_survey
        @params['assign_servicing_loan_outstanding'] = 'X'
        @params['assign_servicing_loan_before_first_payment'] = 'X'
        @params['loan_will_be_serviced'] = 'X'
      end
    end
  end
end
