module Docusign
  module Templates
    class GenericExplanation
      attr_accessor :loan, :borrower, :params

      def initialize(loan)
        @loan = loan
        @borrower = loan.borrower
        @params = {}

        build_content
      end

      private

      def build_content
        @params['borrower_name'] = "#{borrower.first_name} #{borrower.last_name}".titleize
        @params['borrower_address'] = borrower.display_current_address
        @params['pre_signature'] = "Regards"
        @params['explanation_text_box'] = {
          width: 600,
          height: 250,
          value: ''
        }
      end
    end
  end
end